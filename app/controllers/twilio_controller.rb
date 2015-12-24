class TwilioController < ApplicationController
  include Webhookable


  def status
    @message = Message.find(params[:id])
    @message.update_attributes(sid: params["MessageSid"], status: params["SmsStatus"])
    render_twiml Twilio::TwiML::Response.new
  end

  # TODO clean up code
  def receive
    @message = Message.where(to: params["From"]).order("id Desc").limit(1).first
    if !@message.blank?
      if @message.kind == 'OptIn'
        @customer = Customer.find_by_phone(@message.to)
        @opt_in = OptIn.find_by_customer_id(@customer.id)

        if (!@opt_in.completed) && (params["Body"] == @opt_in.verification_code)
          @opt_in.completed = true
          @opt_in.save
          Resque.enqueue(MessageSender, '+16015644274', @customer.phone, @opt_in.subscription.options.welcome_message, 'OptIn')
        end
      end
    end
    head status: 200
  end

end
