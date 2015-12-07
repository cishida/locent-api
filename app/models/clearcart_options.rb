class ClearcartOptions < ActiveRecord::Base
  acts_as_paranoid
  has_one  :subscription, as: :options, dependent: :destroy




  def self.defaults
    default_hash = {
        opt_in_message: 'Text YES to complete opt-in to Clearcart or NO to cancel opt-in.',
        opt_in_refusal_message: 'You have successfully cancelled opt-in to Clearcart.',
        welcome_message: 'Welcome to Clearcart. You will receive SMS notifications when there are deals on items in your cart.',
        initial_cart_abandonment_message: 'The {ITEM} in your cart is now {DISCOUNT} off. Text YES to buy it now!',
        follow_up_message: '{ITEM} is {DISCOUNT} still off and is still in your cart. Reply with YES to buy it now!',
        confirmation_message: 'Your {PRICE} order for {ITEM} is on the way! Your order number is {ORDERNUMBER}',
        number_of_times_to_message: 3,
        time_interval_between_messages: 72
    }
  end
end
