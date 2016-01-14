class TwilioController < ApplicationController
  include Webhookable


  def status
    @message = Message.find(params[:id])
    @message.update_attributes(sid: params["MessageSid"], status: params["SmsStatus"])
    render_twiml Twilio::TwiML::Response.new
  end

  def receive
    create_incoming_message
    handle_incoming_message_appropriately
    head status: 200
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
    get_last_message_sent_to_customer
    set_customer
    set_purpose
    set_incoming_message_purpose
    if is_opt_in?
      handle_if_opt_in_message
    elsif is_safetext?
      handle_if_safetext_message
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

  def is_safetext?
    @purpose.feature == "safetext" && !@purpose.completed
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
      @order.save
    end
    notify_organization_of_customer_intent
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
    @customer = Customer.find_by_phone(@incoming_message.from)
  end

  def customer_intends_to_complete_opt_in?
    (!@opt_in.completed) && (@incoming_message.body.upcase == @opt_in.verification_code)
  end

  def customer_intends_to_cancel_opt_in?
    @incoming_message.body.upcase == "NO"
  end

  def customer_intends_to_confirm_payment?
    (!@order.confirmed) && (@incoming_message.body.upcase == "PAY")
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
  end

  def get_appropriate_status_string
    if @order.confirmed
      return "confirmed"
    elsif !@order.confirmed && customer_intends_to_cancel_payment?
      return "cancelled"
    end
  end

  def get_order_opt_in
    @opt_in = @order.opt_in
  end

end
