class Dashboard::V1::FeaturesController < DashboardController
  before_action :authenticate_user!

  def index
    respond_with Feature.all
  end

end