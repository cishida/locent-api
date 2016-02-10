class Dashboard::V1::StatsController < DashboardController
  before_action :set_organization
  before_action :set_stats
  before_action :set_time_constraints

  def dashboard
    set_dashboard_stats
    respond_with @stats.to_json
  end


  def stats
    set_feature_and_subscription
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

  def set_messages_count
    order_messages_count = Message.includes(:purpose)
                               .where(purpose_type: "Order", organization_id: @organization.id).between_times(@from, @to)
                               .select { |message| message.purpose.feature == params[:feature] }.count
    opt_in_messages_count = Message.includes(:purpose)
                                .where(purpose_type: "OptIn", organization_id: @organization.id).between_times(@from, @to)
                                .select { |message| message.purpose.feature_id == @feature.id }.count
    @stats[:messages] = opt_in_messages_count + order_messages_count
  end

  def set_orders_count
    @successful_orders = Order.where(feature: params[:feature], status: "successful", completed: true).between_times(@from, @to)
    @successful_orders_count_during_previous_period = Order.where(feature: params[:feature], status: "successful", completed: true)
                                                          .between_times(@previous_from, @previous_to)

    @stats[:orders] = @successful_orders.count
    @stats[:orders_percentage_change] = percentage_change(@stats[:orders], @successful_orders_count_during_previous_period.count)
  end

  def set_total_revenue
    price_sum = @successful_orders.sum(:price)
    @stats[:total_revenue] = price_sum.to_s
    @stats[:total_revenue_percentage_change] = percentage_change(price_sum, @successful_orders_count_during_previous_period.sum(:price))
  end

  def set_safetext_graph_data
    safetext_graph_array = []
    orders = Order.where(feature: params[:feature], completed: true).between_times(@from, @to)
    if is_day_query?
      orders.group_by { |order| order.created_at.beginning_of_hour }.each do |hour, orders|
        safetext_graph_array << {
            period: hour,
            successful: orders.select { |order| order.status == "successful" }.count,
            failed: orders.select { |order| order.status == "successful" }.count
        }
      end
    else
      orders.group_by { |order| order.created_at.to_date }.each do |day, orders|
        safetext_graph_array << {
            period: day,
            successful: orders.select { |order| order.status == "successful" }.count,
            failed: orders.select { |order| order.status == "successful" }.count}
      end
    end
    @stats[:graph] = safetext_graph_array
  end

  def set_clearcart_graph_data
    clearcart_revenues_array = []
    if is_day_query?
      @successful_orders.group_by { |order| order.created_at.beginning_of_hour }.each do |hour, orders|
        clearcart_revenues_array << {
            period: hour,
            revenue: orders.sum(:price).to_s,
        }
      end
    else
      @successful_orders.group_by { |order| order.created_at.beginning_of_hour }.each do |day, orders|
        clearcart_revenues_array << {
            period: day,
            revenue: orders.sum(:price).to_s,
        }
      end
    end
    @stats[:graph] = clearcart_revenues_array
  end

  def set_failed_orders_count
    @stats[:failed_orders] = Order.where(feature: params[:feature], status: "successful", completed: true)
                                 .between_times(@from, @to).count
  end

  def set_customers_count
    @stats[:customers] = OptIn.where(subscription_id: @subscription.id, completed: true)
                             .select { |opt_in| opt_in.feature_id == @feature.id }.count
  end

  def set_active_customers_count
    active_customers_during_previous_period = Order.where(status: "successful", organization_id: @organization.id, feature: params[:feature])
                                                  .between_times(@previous_from, @previous_to).group_by(&:opt_in_id).count

    @stats[:active_customers] = Order.where(status: "successful", organization_id: @organization.id, feature: params[:feature])
                                    .between_times(@from, @to).group_by(&:opt_in_id).count
    @stats[:active_customers_percentage_change] = percentage_change(@stats[:active_customers], active_customers_during_previous_period)
  end

  def set_product_revenues
    product_revenues_array = []
    Order.where(feature: params[:feature], organization_id: @organization.id, status: "successful")
        .between_times(@from, @to).group_by(&:description).each do |item, orders|
      product_revenues_array << {
          product_name: item,
          revenue: orders.sum(&:price).to_s,
      }
    end
    @stats[:products] = product_revenues_array
  end

  def set_dashboard_stats
    @messages = Message.where(organization_id: @organization.id).between_times(@from, @to)
    @stats[:messages] = @messages.count
    set_dashboard_successful_orders
    set_dashboard_revenue
    set_dashboard_active_customers_count
    set_dashboard_customers_count
    set_dashboard_opt_ins_count
    set_dashboard_opt_outs_count
    set_dashboard_graph_data
  end


  def set_dashboard_successful_orders
    @dashboard_successful_orders = Order.where(status: "successful", completed: true).between_times(@from, @to)
    @stats[:orders] = @dashboard_successful_orders.count
  end

  def set_dashboard_revenue
    revenue = @dashboard_successful_orders.sum(:price)
    revenue_during_previous_period = Order.where(status: "successful", completed: true).between_times(@previous_from, @previous_to).sum(:price)

    @stats[:average_purchase] = @dashboard_successful_orders.average(:price).to_s
    @stats[:total_revenue] = revenue
    @stats[:revenue_percentage_change] = percentage_change(revenue, revenue_during_previous_period)
  end


  def set_dashboard_active_customers_count
    active_customers_during_previous_period = Order.where(status: "successful", organization_id: @organization.id)
                                                  .between_times(@previous_from, @previous_to).group_by(&:opt_in_id).count

    @stats[:active_customers] = Order.where(status: "successful", organization_id: @organization.id).between_times(@from, @to).group_by(&:opt_in_id).count
    @stats[:active_customers_percentage_change] = percentage_change(@stats[:active_customers], active_customers_during_previous_period)
  end


  def set_dashboard_customers_count
    @stats[:customers] = OptIn.includes(:subscription).where(completed: true).select { |opt_in| opt_in.subscription.organization == @organization }.count
  end

  def set_dashboard_opt_ins_count
    @stats[:opt_ins] = OptIn.includes(:subscription).where(completed: true).between_times(@from, @to).select { |opt_in| opt_in.subscription.organization == @organization }.count
  end


  def set_dashboard_opt_outs_count
    @stats[:opt_outs] = OptIn.unscoped.includes(:subscription).where(active: false, deleted_at: nil).between_times(@from, @to, field: :updated_at)
                            .select { |opt_in| opt_in.subscription.organization == @organization }.count
  end

  def set_dashboard_graph_data
    messages = Message.where(organization_id: @organization.id).between_times(@from, @to)
    dashboard_graph_array = []
    if is_day_query?
      @dashboard_successful_orders.group_by { |order| order.created_at.beginning_of_hour }.each do |hour, orders|
        dashboard_graph_array << {
            period: hour,
            orders: orders.count,
            messages: messages.select { |message| message.created_at.beginning_of_hour == hour }.count
        }
      end
    else
      @dashboard_successful_orders.group_by { |order| order.created_at.to_date }.each do |day, orders|
        dashboard_graph_array << {
            period: day,
            orders: orders.count,
            messages: messages.select { |message| message.created_at.to_date == day }.count
        }
      end
    end
    @stats[:graph] = dashboard_graph_array
  end


  def is_day_query?
    (@to - @from).days < 2.days
  end

  def percentage_change(current_stat, previous_stat)
    if previous_stat != 0
      difference = current_stat - previous_stat
      return difference/previous_stat * 100
    end
    return "infinity"
  end


  def set_organization
    @organization = current_user.organization
  end

  def set_stats
    @stats = {}
  end

  def set_feature_and_subscription
    @feature = Feature.find_by_name(params[:feature])
    @subscription = Subscription.find_by_organization_id_and_feature_id(@organization.id, @feature.id)
  end

  def set_time_constraints
    @to = DateTime.strptime(params[:to].to_s, '%s')
    @from = DateTime.strptime(params[:from].to_s, '%s')
    @time_interval = (@from - @to).days
    @previous_to = @from
    @previous_from = (@from - @time_interval)
  end

end

Message.where(organization_id: 17).between_times(Chronic.parse('feb 1'), Chronic.parse('feb 2')).select { |message| message.created_at.beginning_of_day == day }.count
