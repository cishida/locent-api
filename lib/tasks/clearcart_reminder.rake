desc "This task is called by the Heroku scheduler add-on"
task send_clearcart_reminders: :environment do
  puts "Sending Clearcart reminders..."
  Reminder.where(active: true, number_of_times: 1..Float::INFINITY).each do |reminder|
    set_variables reminder
    if is_time_to_send_reminder? reminder
      Resque.enqueue(MessageSender, @organization.from, @customer.phone, @message, @order.to_descriptor_hash, @organization.id)
      reminder.update(number_of_times: reminder.number_of_times - 1, last_sent: Time.now)
    end
  end
  puts "done."
end


def set_variables(reminder)
  @order = reminder.order
  @opt_in = @order.opt_in
  @customer = @opt_in.customer
  @organization = @opt_in.subscription.organization
  @interval = @opt_in.subscription.time_interval_between_messages
  @message = redact_message(@order.opt_in.subscription.options.follow_up_message)
end

def redact_message(message)
  message.gsub!("{ITEM}", @order.description)
  message.gsub!("{PRICE}", "$" + @order.price.to_s)
  message.gsub!("{ORDERNUMBER}", @order.uid.to_s)
  return message
end

def is_time_to_send_reminder? reminder
  ((Time.now.beginning_of_hour - reminder.last_sent.beginning_of_hour)/3600).to_i == @interval
end