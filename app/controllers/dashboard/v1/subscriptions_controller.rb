# @restful_api 1.0
#
# Subscriptions
#
class Dashboard::V1::SubscriptionsController < DashboardController
  before_action :authenticate_user!
  before_action :set_variables, only: [:show, :options, :update_options]


  # @url /dashboard/subscriptions
  # @action POST
  #
  # Subscribes organization to chosen features
  #
  # @required [Array<Integer>] feature_ids The ids of the features the organization is to be subscribed to.
  #
  # @response_field [Campaign] campaign Newly created campaign
  def create
    param! :feature_ids, Array, required: true
    ActiveRecord::Base.transaction do
      subscriptions = []
      feature_ids = params[:feature_ids]
      feature_ids.each do |feature_id|
        feature_name = Feature.find(feature_id).name
        corresponding_options_model = create_options_with_defaults(feature_name)
        subscription = Subscription.create(organization_id: current_user.organization.id, feature_id: feature_id)
        subscription.options = corresponding_options_model
        subscription.save
        subscriptions << subscription
      end
      render json: subscriptions, status: 201
    end
  end

  # @url /dashboard/subscriptions/:id
  # @action GET
  #
  # Get subscription
  #
  # @required [Integer] id The subscription id
  #
  # @response_field [Subscription] subscription
  def show
    respond_with @subscription
  end

  # @url /dashboard/subscriptions/:id/options
  # @action GET
  #
  # Get subscription's options
  #
  # @required [Integer] id The subscription id
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

  def set_variables
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
    params.permit(:opt_in_message,
                  :opt_in_refusal_message,
                  :welcome_message,
                  :transactional_message,
                  :confirmation_message,
                  :cancellation_message,
                  :opt_in_confirmation_url,
                  :opt_in_verification_url,
                  :purchase_request_url,
                  :opt_in_invalid_message_response
    )
  end

  def safetext_options_params
    params.permit(:opt_in_message,
                  :opt_in_refusal_message,
                  :opt_in_confirmation_url,
                  :opt_in_verification_url,
                  :purchase_request_url,
                  :welcome_message,
                  :transactional_message,
                  :cancellation_message,
                  :confirmation_message,
                  :invalid_message_response,
                  :opt_in_invalid_message_response
    )
  end

  def clearcart_options_params
    params.permit(:opt_in_message,
                  :opt_in_refusal_message,
                  :welcome_message,
                  :initial_cart_abandonment_message,
                  :follow_up_message,
                  :confirmation_message,
                  :number_of_times_to_message,
                  :time_interval_between_messages,
                  :opt_in_confirmation_url,
                  :opt_in_verification_url,
                  :purchase_request_url,
                  :invalid_message_response,
                  :opt_in_invalid_message_response
    )
  end


end
