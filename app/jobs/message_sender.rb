class MessageSender
  @queue = :messaging



  def self.perform from, to, body
    @client = Twilio::REST::Client.new 'ACf9578d77d83865c499ff633de7206458', '1bf81b86fda92238873dba5d84fb6204'
    @client.account.messages.create from: from, to: to, body: body
  end


end