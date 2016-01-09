class Dashboard::V1::SubscriptionsController < DashboardController
  before_action :authenticate_user!
  before_action :set_subscription, only: [:show, :options, :update_options]



  def create
    param! :feature_ids, Array, required: true
    subscriptions = []
    feature_ids = params[:feature_ids]
    feature_ids.each do |feature_id|
      feature_name = Feature.find(feature_id).name.capitalize
      corresponding_options_model = create_options_with_defaults(feature_name)
      subscription = Subscription.create(organization_id: current_user.organization.id, feature_id: feature_id)
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

  def create_options_with_defaults feature_name
    options_class = (feature_name + "Options").constantize
    options_class.new(options_class.defaults)
  end

  def subscription_params
    params.permit(:feature_ids)
  end

  def options_params
    Feature.all.each do |feature|
      if @subscription.feature == feature
        options_params_method_string = (feature.name.capitalize + "OptionsParams").snake_case
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
