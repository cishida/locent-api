class Dashboard::V1::OrdersController < DashboardController

  def orders
    param! :feature, String, required: true
    @organization = current_user.organization
    @orders = Order.where(feature: params[:feature], organization_id: @organization.id)
    paginate json: @orders
  end



end