class Dashboard::V1::OrdersController < DashboardController

  def orders
    param! :feature, String, required: true
    @organization = current_user.organization
    @orders = Order.find_by_feature_and_organization_id(params[:feature], @organization.id)

    paginate json: @orders
  end


end