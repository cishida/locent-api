class Dashboard::V1::FeaturesController < DashboardController

  def index
    respond_with Feature.all
  end

end