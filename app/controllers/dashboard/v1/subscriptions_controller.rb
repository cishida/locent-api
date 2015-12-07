class Dashboard::V1::SubscriptionsController < ActionController::API
  include ActionController::ImplicitRender
  respond_to :json


  def create
    subscriptions = []
    product_ids = params[:product_ids].split(",").map { |s| s.to_i }
    product_ids.each do |product_id|
      product_name = Product.find(product_id).name
      corresponding_options_model = (product_name + "Options").constantize.new
      subscription = Subscription.create(organisation_id: params[:organisation_id], product_id: product_id)
      subscription.option = corresponding_options_model
      subscription.save
      subscriptions << subscription
    end
    render json: subscriptions, status: 201
  end


  private

  def subscription_params
    params.permit(:organisation_id, :product_ids)
  end

end
