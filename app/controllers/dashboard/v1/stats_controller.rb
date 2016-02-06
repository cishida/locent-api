class Dashboard::V1::StatsController < DashboardController
  before_action :set_organization

  def keyword
    param! :from, DateTime, required: true
    param! :to, DateTime, required: true
    @feature = Feature.find_by_name("keyword")
    @subscription = Subscription.find_by_organization_id_and_feature_id(@organization.id, @feature.id)
    set_values_for_response
    render json: keyword_response, status: 204
  end



  private

  def keyword_response
    {
      messages: @messages_count,
      customers: @completed_opt_ins_count,
      active_customers: @active_customers_count,
      orders: @successful_orders_count,
      total_revenue: @total_revenue
    }.to_json
  end

  def set_values_for_response_hash
    @messages_count = Message.where(purpose_type: "Order", organization_id: @organization.id)
                          .union(Message.where(purpose_type: "OptIn", organization_id: @organization.id))
                          .between_times(param[:from], param[:to])
                          .select { |message| message.purpose.feature == "keyword" }
                          .count

    @completed_opt_ins_count = OptIn.where(subscription_id: @subscription.id, completed: true)
                                   .between_times(param[:from], param[:to])
                                   .select { |message| message.purpose.feature == "keyword" }
                                   .count

    @active_customers_count = OptIn.where(subscription_id: @subscription.id, completed: true)
                                  .between_times(param[:from], param[:to])
                                  .select { |opt_in| opt_in.has_at_least_one_successful_order? }
                                  .count

    successful_orders = Order.where(feature: "keyword", status: "successful", completed: true)
                            .between_times(param[:from], param[:to])

    @successful_orders_count = successful_orders.count
    @total_revenue = successful_orders.sum(:price)
  end

  def set_organization
    @organization = current_user.organization
  end
end