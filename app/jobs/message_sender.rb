class MessageSender
  extend Resque::Plugins::WaitingRoom
  def self.queue; :messaging end

  can_be_performed times: 1, period: 1

  def self.perform from, to, body, purpose, organization_id
    create_new_message from, to, body, purpose, organization_id
    create_twilio_client
    send_message
  end

  private

  def self.create_new_message from, to, body, purpose, organization_id
    @message = Message.create(
        from: from,
        to: to,
        body: body,
        kind: "outgoing",
        purpose_type: purpose["class_name"],
        purpose_id: purpose["id"],
        organization_id: organization_id
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


class CriticalPriorityMessageSender < MessageSender
  def self.queue; :critical end
end

class HighPriorityMessageSender < MessageSender
  def self.queue; :high end
end

class MessageSenderWithShortcode < MessageSender
  can_be_performed times: 30, period: 1
end

class HighPriorityMessageSenderWithShortcode < MessageSenderWithShortcode
  def self.queue; :high end
end

class CriticalPriorityMessageSenderWithShortcode < MessageSenderWithShortcode
  def self.queue; :critical end
end