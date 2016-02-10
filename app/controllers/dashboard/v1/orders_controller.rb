# @restful_api 1.0
#
# Orders
#
class Dashboard::V1::OrdersController < DashboardController


  # @url /dashboard/orders/:feature
  # @action GET
  #
  # Get a paginated list of all the orders made from this organization with specified feature
  #
  # @required [String] feature The feature e.g 'keyword'
  #
  # @response_field [Array<Order>] orders List of orders made from this organization with specified feature
  def orders
    param! :feature, String, required: true
    @organization = current_user.organization
    @orders = Order.where(feature: params[:feature], organization_id: @organization.id)
    paginate json: @orders
  end



end