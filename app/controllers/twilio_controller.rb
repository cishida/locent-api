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
    @last_message_to_customer = Message.where(to: @incoming_message.from).order("id Desc").limit(1).first
  end

  def is_opt_in?
    @purpose.is_a? OptIn
  end

  def is_safetext?
    @purpose.is_a? Safetext
  end


  def handle_if_opt_in_message
    set_opt_in
    if customer_intends_to_complete_opt_in?
      @opt_in.completed = true
      @opt_in.save
      send_welcome_message
    elsif customer_intends_to_cancel_opt_in?
      send_cancellation_message
      @opt_in.destroy
    end
  end

  def handle_if_safetext_message
    set_safetext
    get_safetext_opt_in
    if customer_intends_to_confirm_payment?
      @safetext.confirmed = true
      @safetext.save
    elsif customer_intends_to_cancel_payment?
      send_safetext_cancellation_message
      @safetext.destroy
    end
    notify_of_confirmation_or_cancellation
  end

  def set_opt_in
    @opt_in = @purpose
  end

  def set_safetext
    @safetext = @purpose
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
    (!@safetext.confirmed) && (@incoming_message.body.upcase == "PAY")
  end

  def customer_intends_to_cancel_payment?
    customer_intends_to_cancel_opt_in?
  end

  def send_welcome_message
    message_body = @opt_in.subscription.options.welcome_message
    Resque.enqueue(MessageSender, '+16015644274', @customer.phone, message_body, @opt_in.to_descriptor_hash)
  end

  def send_cancellation_message
    message_body = @opt_in.subscription.options.opt_in_refusal_message
    Resque.enqueue(MessageSender, '+16015644274', @customer.phone, message_body, @opt_in.to_descriptor_hash)
  end

  def send_safetext_cancellation_message
    redact_cancellation_message
    Resque.enqueue(MessageSender, '+16015644274', @customer.phone, @cancellation_message, @safetext.to_descriptor_hash)
  end

  def notify_of_confirmation_or_cancellation
    purchase_request_url = @opt_in.subscription.options.purchase_request_url
    puts purchase_request_url
    construct_safetext_post_params
    RestClient.post(purchase_request_url, @post_params.to_json) { |response, request, result, &block|
      case response.code
        when 200
          # TODO
        else
          # TODO
      end
    }
  end

  def construct_safetext_post_params
    @post_params = {
        status: get_appropriate_status_string,
        order_uid: @safetext.order_uid
    }
  end

  def get_appropriate_status_string
    if @safetext.confirmed
      return "confirmed"
    else
      return "cancelled"
    end
  end

  def get_safetext_opt_in
    @opt_in = OptIn.joins(:subscription).where(
        customer_id: @customer.id,
        product_id: 3,
        completed: true,
        subscriptions: {
            organization_id: @customer.organization_id
        }
    ).first
  end

  def redact_cancellation_message
    cancellation_message = @opt_in.subscription.options.cancellation_message
    cancellation_message.gsub!("{ITEM}", @safetext.item_name)
    cancellation_message.gsub!("{PRICE}", "$" + @safetext.item_price.to_s)
    @cancellation_message = cancellation_message
  end

end
