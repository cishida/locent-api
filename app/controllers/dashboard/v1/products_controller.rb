class Dashboard::V1::ProductsController < DashboardController
  before_action :authenticate_user!
  before_action :set_variables

  def create
    validate_create_params
    @product = Product.new(product_params)
    @product.subscription = @subscription
    @product.organization = @organization
    if @product.save
      render json: @product, status: 201, location: [:dashboard, @product]
    else
      render json: {errors: @product.full_messages}, status: 422
    end
  end

  def show
    param! :feature, String, required: true
    respond_with @subscription.products
  end

  private

  def validate_create_params
    param! :name, String, required: true
    param! :uid, String, required: true
    param! :feature, String, required: true
    param! :keyword, String, required: true
    param! :price, BigDecimal, required: true
  end

  def set_variables
    @organization = current_user.organization
    @feature = Feature.find_by_name(params[:feature].capitalize)
    @subscription = Subscription.find_by_organization_id_and_feature_id(@organization.id, @feature.id)
  end

  def product_params
    params.permit(:name, :uid, :keyword, :price)
  end
end