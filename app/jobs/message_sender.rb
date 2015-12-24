class MessageSender
  extend Resque::Plugins::WaitingRoom
  @queue = :messaging

  can_be_performed times: 1, period: 1

  def self.perform from, to, body, kind
    create_new_message from, to, body, kind
    create_twilio_client
    send_message
  end

  private

  def self.create_new_message from, to, body, kind
    @message = Message.create(
        from: from,
        to: to,
        body: body,
        kind: kind
    )
  end

  def self.create_twilio_client
    @client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
  end

  def self.send_message
    @client.account.messages.create(
        from: @message.from,
        to: @message.to,
        body: @message.body,
        status_callback: "http://d56bdcaf.ngrok.io/status/#{@message.id}"
    )
  end


end