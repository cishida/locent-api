class Dashboard::V1::StatsController < DashboardController
  before_action :set_organization

  def keyword
    @feature = Feature.find_by_name(params[:feature])
    @subscription = Subscription.find_by_organization_id_and_feature_id(@organization.id, @feature.id)

    messages_count = Message.where(purpose_type: "Order", organization: @organization).select{ |message| message.purpose.feature == "keyword"}.count
    active_customers_count = OptIn.where()


  end

  private

  def set_organization
    @organization = current_user.organization
  end
end