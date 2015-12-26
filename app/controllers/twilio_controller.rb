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
    if is_opt_in?
      handle_if_opt_in_message
    end
  end


  def get_last_message_sent_to_customer
    @last_message_to_customer = Message.where(to: @incoming_message.from).order("id Desc").limit(1).first
  end

  def is_opt_in?
    @last_message_to_customer.purpose is_a? OptIn
  end


  def handle_if_opt_in_message
    set_opt_in
    set_incoming_message_purpose
    set_customer
    if customer_intends_to_complete_opt_in?
      @opt_in.completed = true
      @opt_in.save
      send_welcome_message
    elsif customer_intends_to_cancel_opt_in?
      @opt_in.destroy
      send_cancellation_message
    end
  end

  def set_opt_in
    @opt_in = @last_message_to_customer.purpose
  end

  def set_incoming_message_purpose
    @incoming_message.purpose = @opt_in
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

  def send_welcome_message
    message_body = @opt_in.subscription.options.welcome_message
    Resque.enqueue(MessageSender, '+16015644274', @customer.phone, message_body, @opt_in.to_descriptor_hash)
  end

  def send_cancellation_message
    message_body = @opt_in.subscription.options.opt_in_refusal_message
    Resque.enqueue(MessageSender, '+16015644274', @customer.phone, message_body, @opt_in.to_descriptor_hash)
  end




end
