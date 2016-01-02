class Dashboard::V1::SubscriptionsController < DashboardController
  before_action :authenticate_user!
  before_action :set_subscription, only: [:show, :options, :update_options]



  def create
    param! :product_ids, Array, required: true
    subscriptions = []
    product_ids = params[:product_ids]
    product_ids.each do |product_id|
      product_name = Product.find(product_id).name.capitalize
      corresponding_options_model = create_options_with_defaults(product_name)
      subscription = Subscription.create(organization_id: current_user.organization.id, product_id: product_id)
      subscription.options = corresponding_options_model
      subscription.save
      subscriptions << subscription
    end
    render json: subscriptions, status: 201
  end

  def show
    respond_with @subscription
  end

  def options
    respond_with @options
  end

  def update_options
    if @options.update(options_params)
      render json: @options, status: 201
    else
      render json: {errors: @options.errors.full_messages}, status: 422
    end
  end


  private

  def set_subscription
    @subscription = Subscription.find(params[:id])
    @options = @subscription.options
    unless current_user.organization.subscriptions.exists?(@subscription)
      render json: {errors: ["Authorized users only."]}, status: 401
    end
  end

  def create_options_with_defaults product_name
    options_class = (product_name + "Options").constantize
    options_class.new(options_class.defaults)
  end

  def subscription_params
    params.permit(:product_ids)
  end

  def options_params
    Product.all.each do |product|
      if @subscription.product == product
        options_params_method_string = (product.name.capitalize + "OptionsParams").snake_case
        return self.send(options_params_method_string)
      end
    end
  end

  def keyword_options_params
    params.permit(:opt_in_message, :opt_in_refusal_message, :welcome_message, :transactional_message,
                  :confirmation_message, :cancellation_message)
  end

  def safetext_options_params
    params.permit(:opt_in_message,
                  :opt_in_refusal_message,
                  :welcome_message,
                  :transactional_message,
                  :cancellation_message,
                  :confirmation_message)
  end

  def clearcart_options_params
    params.permit(:opt_in_message, :opt_in_refusal_message, :welcome_message,
                  :initial_cart_abandonment_message, :follow_up_message, :confirmation_message,
                  :number_of_times_to_message, :time_interval_between_messages)
  end


end
