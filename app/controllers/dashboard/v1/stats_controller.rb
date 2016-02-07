class Dashboard::V1::StatsController < DashboardController
  before_action :set_organization


  def stats
    set_variables
    set_common_stats
    case params[:feature]
      when "keyword"
        add_keyword_specific_stats
      when "clearcart"
        add_clearcart_specific_stats
      when "safetext"
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
    @successful_orders_count = successful_orders.count
  end

  def set_total_revenue
    @total_revenue = successful_orders.sum(:price)
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

  def set_clearcart_graph_data
    @clearcart_revenues_array = []
    if (@to - @from).beginning_of_day.day == 1.day
      @successful_orders.group("DATE_TRUNC('hour', created_at)").each do |hour, orders|
        @clearcart_revenues_array << {
            hour: hour,
            revenue: orders.sum(:price),
        }
      end
    else
      @successful_orders.group("DATE_TRUNC('day', created_at)").each do |day, orders|
        @clearcart_revenues_array << {
            day: day,
            revenue: orders.sum(:price),
        }
      end
    end
    @stats[:graph] = @clearcart_revenues_array
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
          revenue: orders.sum(:price),
      }
    end
    @stats[:products] = @product_revenues_array
  end

  def set_variables
    @to = DateTime.strptime(params[:to], '%s')
    @from = DateTime.strptime(params[:from], '%s')
    @feature = Feature.find_by_name(params[:feature])
    @subscription = Subscription.find_by_organization_id_and_feature_id(@organization.id, @feature.id)
  end

  def set_organization
    @organization = current_user.organization
  end

end