class MessageSender
  extend Resque::Plugins::WaitingRoom
  @queue = :messaging

  can_be_performed times: 1, period: 1

  def self.perform from, to, body, purpose
    create_new_message from, to, body, purpose
    create_twilio_client
    send_message
  end

  private

  def self.create_new_message from, to, body, purpose
    @message = Message.create(
        from: from,
        to: to,
        body: body,
        kind: "outgoing",
        purpose_type: purpose["class_name"],
        purpose_id: purpose["id"]
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
        status_callback: "http://locent-api.heroku.com/status/#{@message.id}"
    )
  end


end