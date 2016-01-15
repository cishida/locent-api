# @restful_api 1.0
#
# Features
#

class Dashboard::V1::FeaturesController < DashboardController
  before_action :authenticate_user!

  # @url /features
  # @action GET
  #
  # Get a list of all of Locent's features
  #
  # @response_field [Array<Feature>] list of features available on Locent
  def index
    respond_with Feature.all
  end

end