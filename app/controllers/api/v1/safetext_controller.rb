class Api::V1::SafetextController < ApiController

  def create
    validate_create_params
    @subscription = Subscription.find_by_organization_id_and_feature_id(@organization.id, 3)
    find_and_set_opt_in
    create_new_safetext
    send_initial_safetext_message
    head status: 201
  end

  def order_status
    validate_order_status_params
    set_safetext
    @safetext.order_success = params[:order_success]
    @safetext.completed = true
    @safetext.true
    send_safetext_welcome_message
  end

  private

  def create_new_safetext
    @safetext = Safetext.create(
        order_uid: params[:order_uid],
        item_name: params[:item_name],
        item_price: params[:item_price],
        opt_in_id: @opt_in.id
    )
  end

  def validate_create_params
    param! :customer_uid, String, required: true
    param! :customer_phone_number, String, required: true
    param! :order_uid, String, required: true
    param! :item_price, BigDecimal, required: true
    param! :item_name, String, required: true
  end

  def validate_order_status_params
    param! :order_uid, String, required: true
    param! :order_success, :boolean, required: true
  end

  def send_initial_safetext_message
    transactional_message = redact_message(@subscription.options.transactional_message)
    Resque.enqueue(MessageSender, @organization.from, @customer.phone, transactional_message, @safetext.to_descriptor_hash)
  end

  def send_safetext_welcome_message
    confirmation_message = redact_message(@opt_in.subscription.options.confirmation_message)
    Resque.enqueue(MessageSender, @organization.from, @customer.phone, confirmation_message, @safetext.to_descriptor_hash)
  end


  def send_safetext_cancellation_message
    cancellation_message = redact_message(@opt_in.subscription.options.cancellation_message)
    Resque.enqueue(MessageSender, @organization.from, @customer.phone, cancellation_message, @safetext.to_descriptor_hash)
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
    message.gsub!("{ITEM}", @safetext.item_name)
    message.gsub!("{PRICE}", "$" + @safetext.item_price.to_s)
    message.gsub!("{ORDERNUMBER}", @safetext.order_uid.to_s)
    return message
  end

  def set_safetext
    @safetext = Safetext.find_by_order_uid(params[:order_uid])
    @opt_in = @safetext.opt_in
    @customer = @opt_in.customer
  end

end