class Dashboard::V1::StatsController < DashboardController
  before_action :set_organization

  def dashboard
    set_time_constraints
    set_dashboard_stats
    set_dashboard_graph_data
    respond_with @stats.to_json
  end


  def stats
    set_variables
    set_common_stats
    case params[:feature]
      when "keyword"
        add_keyword_specific_stats
      when "clearcart"
        add_clearcart_specific_stats
      when "safetext"
        add_safetext_specific_stats
    end
    respond_with @stats.to_json
  end


  private

  def set_common_stats
    set_messages_count
    set_orders_count
    set_total_revenue
    set_stats_hash
  end

  def set_messages_count
    order_messages_count = Message.where(purpose_type: "Order", organization_id: @organization.id)
                               .between_times(@from, @to)
                               .select { |message| message.purpose.feature == params[:feature] }
                               .count

    opt_in_messages_count = Message.where(purpose_type: "OptIn", organization_id: @organization.id)
                                .between_times(@from, @to)
                                .select { |message| message.purpose.feature_id == @feature.id }
                                .count

    @messages_count = opt_in_messages_count + order_messages_count
  end

  def set_orders_count
    @successful_orders = Order.where(feature: params[:feature], status: "successful", completed: true)
                             .between_times(@from, @to)
    @successful_orders_count = @successful_orders.count
  end

  def set_total_revenue
    @total_revenue = @successful_orders.sum(:price).to_s
  end

  def set_stats_hash
    @stats = {
        messages: @messages_count,
        orders: @successful_orders_count,
        total_revenue: @total_revenue
    }
  end

  def add_keyword_specific_stats
    set_customers_count
    set_active_customers_count
    set_product_revenues
  end

  def add_clearcart_specific_stats
    set_clearcart_graph_data
  end

  def add_safetext_specific_stats
    set_safetext_graph_data
    set_active_customers_count
    set_failed_orders_count
  end

  def set_safetext_graph_data
    @safetext_graph_array = []
    orders = Order.where(feature: params[:feature], completed: true)
                 .between_times(@from, @to)
    if is_day_query?
      orders.group_by { |order| order.created_at.beginning_of_hour }.each do |hour, orders|
        @safetext_graph_array << {
            period: hour,
            successful: orders.select { |order| order.status == "successful" }.count,
            failed: orders.select { |order| order.status == "successful" }.count
        }
      end
    else
      orders.group_by { |order| order.created_at.to_date }.each do |day, orders|
        @safetext_graph_array << {
            period: day,
            successful: orders.select { |order| order.status == "successful" }.count,
            failed: orders.select { |order| order.status == "successful" }.count}
      end
    end
    @stats[:graph] = @safetext_graph_array
  end

  def set_clearcart_graph_data
    @clearcart_revenues_array = []
    if is_day_query?
      @successful_orders.group_by { |order| order.created_at.beginning_of_hour }.each do |hour, orders|
        @clearcart_revenues_array << {
            period: hour,
            revenue: orders.sum(:price).to_s,
        }
      end
    else
      @successful_orders.group_by { |order| order.created_at.beginning_of_hour }.each do |day, orders|
        @clearcart_revenues_array << {
            period: day,
            revenue: orders.sum(:price).to_s,
        }
      end
    end
    @stats[:graph] = @clearcart_revenues_array
  end

  def set_failed_orders_count
    @failed_orders_count = Order.where(feature: params[:feature], status: "successful", completed: true)
                               .between_times(@from, @to).count
    @stats[:failed_orders] = @failed_orders_count
  end

  def set_customers_count
    @completed_opt_ins_count = OptIn.where(subscription_id: @subscription.id, completed: true)
                                   .between_times(@from, @to)
                                   .select { |opt_in| opt_in.feature_id == @feature.id }
                                   .count
    @stats[:customers] = @completed_opt_ins_count
  end

  def set_active_customers_count
    @active_customers_count = OptIn.where(subscription_id: @subscription.id, completed: true)
                                  .between_times(@from, @to)
                                  .select { |opt_in| opt_in.has_at_least_one_successful_order? }
                                  .count
    @stats[:active_customers] = @active_customers_count
  end

  def set_product_revenues
    @product_revenues_array = []
    Order.where(feature: params[:feature], organization_id: @organization.id, status: "successful")
        .between_times(@from, @to).group_by(&:description).each do |item, orders|
      @product_revenues_array << {
          product_name: item,
          revenue: orders.sum(&:price).to_s,
      }
    end
    @stats[:products] = @product_revenues_array
  end

  def set_variables
    set_time_constraints
    @feature = Feature.find_by_name(params[:feature])
    @subscription = Subscription.find_by_organization_id_and_feature_id(@organization.id, @feature.id)
  end

  def set_time_constraints
    @to = DateTime.strptime(params[:to].to_s, '%s')
    @from = DateTime.strptime(params[:from].to_s, '%s')
  end

  def set_organization
    @organization = current_user.organization
  end

  def set_dashboard_stats
    @messages = Message.where(organization_id: @organization.id).between_times(@from, @to)
    set_dashboard_successful_orders
    set_dashboard_active_customers_count
    set_dashboard_customers_count
    set_dashboard_opt_ins_count
    set_dashboard_opt_outs_count
    set_dashboard_stats_hash
  end

  def set_dashboard_stats_hash
    @stats = {
        messages: @messages.count,
        orders: @dashboard_orders_count,
        total_revenue: @dashboard_revenue,
        average_purchase: @dashboard_average_purchase,
        opt_ins: @dashboard_opt_ins_count,
        opt_outs: @dashboard_opt_outs_count,
        customers: @dashboard_customers_count,
        active_customers: @dashboard_active_customers_count
    }
  end

  def set_dashboard_successful_orders
    @dashboard_successful_orders = Order.where(status: "successful", completed: true)
                                       .between_times(@from, @to)
    @dashboard_orders_count = @dashboard_successful_orders.count
    @dashboard_revenue = @dashboard_successful_orders.sum(:price).to_s
    @dashboard_average_purchase = @dashboard_successful_orders.average(:price).to_s
  end

  def set_dashboard_active_customers_count
    count = 0
    @dashboard_active_customers_count = Order.where(status: "successful", organization_id: @organization.id)
                                            .between_times(@from, @to)
                                            .group_by(&:opt_in_id).count
  end

  def set_dashboard_customers_count
    @dashboard_customers_count = OptIn.where(completed: true)
                                     .select { |opt_in| opt_in.subscription.organization == @organization }
                                     .count
  end

  def set_dashboard_opt_ins_count
    @dashboard_opt_ins_count = OptIn.where(completed: true)
                                   .between_times(@from, @to)
                                   .select { |opt_in| opt_in.subscription.organization == @organization }
                                   .count
  end


  def set_dashboard_opt_outs_count
    @dashboard_opt_outs_count = OptIn.unscoped.where(active: false, deleted_at: nil)
                                    .between_times(@from, @to, field: :updated_at)
                                    .select { |opt_in| opt_in.subscription.organization == @organization }
                                    .count
  end

  def set_dashboard_graph_data
    @dashboard_graph_array = []
    if is_day_query?
      @dashboard_successful_orders.group_by { |order| order.created_at.beginning_of_hour }.each do |hour, orders|
        @dashboard_graph_array << {
            period: hour,
            orders: orders.count,
            messages: @messages.select { |message| message.created_at.beginning_of_hour == hour }.count
        }
      end
    else
      @dashboard_successful_orders.group_by { |order| order.created_at.to_date }.each do |day, orders|
        @dashboard_graph_array << {
            period: day,
            orders: orders.count,
            messages: @messages.select { |message| message.created_at.to_date == day }.count
        }
      end
    end
    @stats[:graph] = @dashboard_graph_array
  end


  def is_day_query?
    (@to - @from).days < 2.days
  end

end