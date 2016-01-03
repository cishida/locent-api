class Api::V1::SafetextController < ApiController

  def create
    validate_create_params
    @subscription = Subscription.find_by_organization_id_and_product_id(@organization.id, 3)
    find_and_set_opt_in
    create_new_safetext
    send_safetext_message
    head status: 201
  end

  def order_status

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

  def send_safetext_message
    redact_message
    Resque.enqueue(MessageSender, '+16015644274', @customer.phone, @message_body, @safetext.to_descriptor_hash)
  end

  def redact_message
    transactional_message = @subscription.options.transactional_message
    transactional_message.gsub!("{ITEM}", params[:item_name])
    transactional_message.gsub!("{PRICE}", "$" + params[:item_price].to_s)
    @message_body = transactional_message
  end

  def validate_create_params
    param! :customer_uid, String, required: true
    param! :customer_phone_number, String, required: true
    param! :order_uid, String, required: true
    param! :item_price, BigDecimal, required: true
    param! :item_name, String, required: true
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
      @customer = Customer.find_by_subscription_id_and_uid(@subscription.id, params[:customer_uid])
    else
      @customer = Customer.find_by_subscription_id_and_phone(@subscription.id, params[:phone])
    end
    handle_inexistent_customer
  end

  def handle_inexistent_customer
    if @customer.blank?
      render json: {errors: ["This customer has not opted in to this service or does not exist."]}, status: 401
    end
  end


end