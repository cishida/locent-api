class Dashboard::V1::ProductsController < DashboardController
  def index
    respond_with Product.all
  end

end