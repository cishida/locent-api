class Api::V1::OrdersController < ApiController

  def safetext
    order("safetext")
  end

  def clearcart
    order("clearcart")
  end

  def order_status
    ActiveRecord::Base.transaction do
      validate_order_status_params
      set_order
      if !@order.completed
        @order.order_success = params[:order_success]
        @order.completed = true
        @order.save
        send_appropriate_message
        head status: 204
      else
        head status: 403
      end
    end
  end

  private

  def order(feature)
    ActiveRecord::Base.transaction do
      validate_create_params
      @subscription = Subscription.find_by_organization_id_and_feature_id(@organization.id, 3)
      find_and_set_opt_in
      create_new_order(feature)
      create_reminder_if_clearcart
      send_initial_message
      head status: 204
    end
  end

  def create_new_order(feature)
    set_description_based_on_feature
    @order = Order.create(
        uid: params[:order_uid],
        description: @order_description,
        price: params[:price],
        opt_in_id: @opt_in.id,
        feature: feature,
        organization_id: @organization.id,
        percentage_discount: params[:percentage_discount]
    )
  end


  def set_description_based_on_feature
    if feature == "clearcart"
      @order_description = params[:description]
    else
      @order_description = params[:item_name]
    end
  end

  def create_reminder_if_clearcart
    if is_clearcart?
      Reminder.create(
          number_of_times: @order.opt_in.subscription.options.number_of_times_to_message - 1,
          order_id: @order.id,
          interval: @order.opt_in.subscription.options.time_interval_between_messages
      )
    end
  end

  def is_clearcart?
    @order.feature == "clearcart"
  end

  def validate_create_params
    param! :customer_uid, String, required: true
    param! :customer_phone_number, String, required: true
    param! :order_uid, String, required: true
    param! :price, BigDecimal, required: true
    param! :item_name, String
    param! :description, String
    param! :percentage_discount, Integer
  end

  def validate_order_status_params
    param! :order_uid, String, required: true
    param! :order_success, :boolean, required: true
    param :error_code, Integer
  end

  def send_initial_message
    if is_clearcart?
      initial_message = redact_message(@subscription.options.initial_cart_abandoment_message)
    else
      initial_message = redact_message(@subscription.options.transactional_message)
    end
    Resque.enqueue(MessageSender, @organization.from, @customer.phone, initial_message, @order.to_descriptor_hash, @organization.id)
  end

  def send_appropriate_message
    if @order.order_success
      send_confirmation_message
    elsif !@order_success && !params[:error_code].blank? && Error.find_by_code(params[:code]).exists?
      send_error_message
    else
      send_cancellation_message
    end
  end


  def send_confirmation_message
    confirmation_message = redact_message(@opt_in.subscription.options.confirmation_message)
    Resque.enqueue(MessageSender, @organization.from, @customer.phone, confirmation_message, @order.to_descriptor_hash, @organization.id)
  end

  def send_error_message
    error_message = @organization.error_messages.joins(:error).where({
                                                                         errors: {
                                                                             code: params[:code]
                                                                         }
                                                                     }).first.message
    redacted_error_message = redact_message(error_message)
    Resque.enqueue(MessageSender, @organization.from, @customer.phone, redacted_error_message, @order.to_descriptor_hash, @organization.id)
  end


  def send_cancellation_message
    cancellation_message = redact_message(@opt_in.subscription.options.cancellation_message)
    Resque.enqueue(MessageSender, @organization.from, @customer.phone, cancellation_message, @order.to_descriptor_hash, @organization.id)
  end

  def find_and_set_opt_in
    find_and_set_customer
    @opt_in = OptIn.find_by_customer_id_and_subscription_id(@customer.id, @subscription.id)
    handle_incomplete_opt_in
  end

  def handle_incomplete_opt_in
    if @opt_in.blank? || !@opt_in.completed
      render json: {errors: ["This customer has not opted in to this service."]}, status: 401
    end
  end

  def find_and_set_customer
    if !params[:customer_uid].blank?
      @customer = Customer.find_by_organization_id_and_uid(@subscription.organization.id, params[:customer_uid])
    else
      @customer = Customer.find_by_organization_id_and_phone(@subscription.organization.id, params[:phone])
    end
    handle_inexistent_customer
  end

  def handle_inexistent_customer
    if @customer.blank?
      render json: {errors: ["This customer has not opted in to this service or does not exist."]}, status: 401
    end
  end

  def redact_message(message)
    message.gsub!("{ITEM}", @order.description)
    message.gsub!("{PRICE}", "$" + @order.price.to_s)
    message.gsub!("{ORDERNUMBER}", @order.uid.to_s)
    message.gsub!("{DISCOUNT}", @order.percentage_discount.to_s + "%")
    return message
  end

  def set_order
    @order = Order.find_by_uid(params[:order_uid])
    @opt_in = @order.opt_in
    @customer = @opt_in.customer
  end

end