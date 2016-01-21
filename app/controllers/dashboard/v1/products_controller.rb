class Dashboard::V1::ProductsController < DashboardController
  before_action :authenticate_user!
  before_action :set_variables, except: [:destroy, :update]

  def create
    validate_create_params
    @product = Product.new(product_create_params)
    @product.subscription = @subscription
    @product.organization = @organization
    if @product.save
      render json: @product, status: 201
    else
      render json: {errors: @product.full_messages}, status: 422
    end
  end

  def show
    param! :feature, String, required: true
    paginate json: @subscription.products.order_by("id DESC")
  end

  def update
    validate_update_params
    @product = Product.find_by_uid(params[:uid])
    if @product.update(product_update_params)
      render json: @product, status: 201
    else
      render json: {errors: @product.full_messages}, status: 422
    end
  end


  def destroy
    param! :uid, String, required: true
    @product = Product.find_by_uid(params[:uid])
    @product.destroy
    head status: 204
  end

  private

  def validate_create_params
    param! :name, String, required: true
    param! :uid, String, required: true
    param! :feature, String, required: true
    param! :keyword, String, required: true
    param! :price, BigDecimal, required: true
  end

  def validate_update_params
    param! :name, String
    param! :uid, String, required: true
    param! :keyword, String
    param! :price, BigDecimal
  end

  def set_variables
    @organization = current_user.organization
    @feature = Feature.find_by_name(params[:feature].capitalize)
    @subscription = Subscription.find_by_organization_id_and_feature_id(@organization.id, @feature.id)
  end

  def product_create_params
    params.permit(:name, :uid, :keyword, :price)
  end

  def product_update_params
    params.permit(:name, :keyword, :price)
  end
end