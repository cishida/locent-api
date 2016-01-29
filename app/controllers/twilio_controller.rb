class TwilioController < ApplicationController
  include Webhookable


  def status
    @message = Message.find(params[:id])
    @message.update_attributes(sid: params["MessageSid"], status: params["SmsStatus"])
    render_twiml Twilio::TwiML::Response.new
  end

  def receive
    ActiveRecord::Base.transaction do
      handle_incoming_message_appropriately
      head status: 200
    end
  end

  private

  def create_incoming_message
    @incoming_message = Message.create(
        from: params["From"],
        to: params["To"],
        body: params["Body"],
        sid: params["MessageSid"],
        status: params["SmsStatus"],
        kind: "incoming"
    )
  end


  def handle_incoming_message_appropriately
    create_incoming_message
    get_last_message_sent_to_customer
    set_customer
    set_purpose
    set_incoming_message_purpose
    if is_opt_in?
      handle_if_opt_in_message
    elsif is_keyword?
      handle_if_keyword_message
    elsif is_safetext?
      handle_if_safetext_message
    elsif is_clearcart?
      handle_if_clearcart_message
    end
  end


  def get_last_message_sent_to_customer
    set_organization
    @last_message_to_customer = Message.where(to: @incoming_message.from, from: @organization.from).order("id Desc").limit(1).first
  end

  def set_organization
    @organization = Organization.find_by_short_code(@incoming_message.to)
    if @organization.blank?
      @organization = Organization.find_by_long_number(@incoming_message.to)
    end
  end

  def is_opt_in?
    @purpose.is_a? OptIn
  end

  def is_keyword?
    product_keywords = @organization.products.map(&:keyword)
    product_keywords.map!(&:upcase)
    return product_keywords.include? @incoming_message.body.upcase
  end

  def is_safetext?
    @purpose.feature == "safetext" && !@purpose.completed
  end

  def is_clearcart?
    @purpose.feature == "clearcart" && !@purpose.completed
  end


  def handle_if_opt_in_message
    set_opt_in
    if customer_intends_to_complete_opt_in?
      @opt_in.completed = true
      @opt_in.save
      send_opt_in_welcome_message
    elsif customer_intends_to_cancel_opt_in?
      send_opt_in_cancellation_message
      @opt_in.destroy
    end
  end

  def handle_if_safetext_message
    set_order
    get_order_opt_in
    if customer_intends_to_confirm_payment?
      @order.confirmed = true
    else
      customer_intends_to_cancel_payment?
      @order.confirmed = false
    end
    @order.save
    notify_organization_of_customer_intent
  end

  def handle_if_clearcart_message
    handle_if_safetext_message
  end

  def handle_if_keyword_message
    set_product_and_opt_in
    create_keyword_order
    notify_organization_of_customer_intent
  end

  def set_product_and_opt_in
    @product = Product.find_by_organization_id_and_keyword(@organization.id, @incoming_message.body.upcase)
    subscription = Subscription.find_by_organization_id_and_feature_id(@organization.id, 1)
    @opt_in = OptIn.find_by_subscription_id_and_customer_id(subscription.id, @customer.id)
  end

  def create_keyword_order
    @order = Order.new(
        uid: SecureRandom.uuid.gsub(/\-/, ''),
        description: @product.name,
        price: @product.price,
        opt_in_id: @opt_in.id,
        feature: "keyword",
        organization_id: @organization.id,
        confirmed: true
    )
    @order.save
    @incoming_message.purpose = @order
    @incoming_message.save
  end

  def set_opt_in
    @opt_in = @purpose
  end

  def set_order
    @order = @purpose
  end

  def set_purpose
    @purpose = @last_message_to_customer.purpose
  end

  def set_incoming_message_purpose
    @incoming_message.purpose = @purpose
    @incoming_message.save
  end

  def set_customer
    @customer = Customer.find_by_phone_and_organization_id(@incoming_message.from, @organization.id)
  end

  def customer_intends_to_complete_opt_in?
    (!@opt_in.completed) && (@incoming_message.body.upcase == @opt_in.verification_code)
  end

  def customer_intends_to_cancel_opt_in?
    @incoming_message.body.upcase == "NO"
  end

  def customer_intends_to_confirm_payment?
    if is_clearcart?
      return (!@order.confirmed) && (@incoming_message.body.upcase == "BUY")
    elsif is_safetext?
      return (!@order.confirmed) && (@incoming_message.body.upcase == "PAY")
    end
  end

  def customer_intends_to_cancel_payment?
    customer_intends_to_cancel_opt_in?
  end

  def send_opt_in_welcome_message
    message_body = @opt_in.subscription.options.welcome_message
    Resque.enqueue(MessageSender, @organization.from, @customer.phone, message_body, @opt_in.to_descriptor_hash)
  end

  def send_opt_in_cancellation_message
    message_body = @opt_in.subscription.options.opt_in_refusal_message
    Resque.enqueue(MessageSender, @organization.from, @customer.phone, message_body, @opt_in.to_descriptor_hash)
  end

  def notify_organization_of_customer_intent
    purchase_request_url = @opt_in.subscription.options.purchase_request_url
    puts purchase_request_url
    construct_post_body
    RestClient.post(purchase_request_url, @post_params.to_json) { |response, request, result, &block|
      case response.code
        when 200
          # TODO
        else
          # TODO
      end
    }
  end

  def construct_post_body
    @post_params = {
        status: get_appropriate_status_string,
        order_uid: @order.uid
    }
    append_extra_information_if_necessary
  end

  def append_extra_information_if_necessary
    if @order.feature == "keyword"
      @post_params.merge!(
          product_uid: @product.uid,
          product_name: @product.name
      )
    end
  end

  def get_appropriate_status_string
    if @order.confirmed
      return "confirmed"
    elsif !@order.confirmed
      return "cancelled"
    end
  end

  def get_order_opt_in
    @opt_in = @order.opt_in
  end

end
