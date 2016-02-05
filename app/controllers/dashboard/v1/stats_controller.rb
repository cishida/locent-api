class Dashboard::V1::StatsController < DashboardController
  before_action :set_organization

  def keyword
    @feature = Feature.find_by_name("keyword")
    @subscription = Subscription.find_by_organization_id_and_feature_id(@organization.id, @feature.id)

    messages_count = Message.where(purpose_type: "Order", organization_id: @organization.id).select{ |message| message.purpose.feature == "keyword"}.count
    completed_opt_ins_count = OptIn.where(subscription_id: @subscription.id, completed: true).count
    completed_orders_count = OptIn.where(subscription_id: @subscription.id, completed: true).select { Op}

  end

  private

  def set_organization
    @organization = current_user.organization
  end
end