class Dashboard::V1::StatsController < DashboardController
  before_action :set_organization

  def keyword
    Message.where(purpose_type: "Order", organization: @organization).select{ |message| message.purpose.feature == "keyword"}.count


  end

  private

  def set_organization
    @organization = current_user.organization
  end
end