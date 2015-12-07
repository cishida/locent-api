class Dashboard::V1::SubscriptionsController < ActionController::API
  include ActionController::ImplicitRender
  respond_to :json


  def create
    subscriptions = []
    product_ids = params[:product_ids].split(",").map { |s| s.to_i }
    product_ids.each do |product_id|
      product_name = Product.find(product_id).name.capitalize
      corresponding_options_model = create_options_with_defaults product_name
      subscription = Subscription.create(organisation_id: params[:organisation_id], product_id: product_id)
      subscription.option = corresponding_options_model
      subscription.save
      subscriptions << subscription
    end
    render json: subscriptions, status: 201
  end


  private

  def create_options_with_defaults product_name
    options_class = (product_name + "Options").constantize
    options_class.new(options_class.defaults)
  end

  def subscription_params
    params.permit(:organisation_id, :product_ids)
  end

end
