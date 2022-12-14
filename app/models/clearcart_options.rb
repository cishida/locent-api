# @restful_api 1.0
#
# @property [String] opt_in_message
# @property [String] opt_in_refusal_message
# @property [String] welcome_message
# @property [String] initial_cart_abandonment_message
# @property [String] follow_up_message
# @property [String] confirmation_message
# @property [String] number_of_times_to_message
# @property [String] time_interval_between_messages
# @property [String] opt_in_verification_url
# @property [String] opt_in_confirmation_url
# @property [String] purchase_request_url
# @property [String] invalid_message_response
# @property [String] opt_in_invalid_message_response
#
class ClearcartOptions < ActiveRecord::Base
  acts_as_paranoid
  has_one  :subscription, as: :options, dependent: :destroy

  validates :opt_in_verification_url, :url => {:no_local => true}
  validates :opt_in_confirmation_url, :url => {:no_local => true}
  validates :purchase_request_url, :url => {:no_local => true}

  def self.invalid_message_response
    "Invalid command. Please reply with BUY to clear your cart or NO to cancel the order."
  end

  def self.defaults
    default_hash = {
        opt_in_message: 'Text your confirmation code to complete opt-in to Clearcart or text NO to cancel.',
        opt_in_refusal_message: 'You have successfully cancelled opt-in to Clearcart.',
        welcome_message: 'Welcome to Clearcart. You will receive SMS notifications when there are deals on items in your cart.',
        initial_cart_abandonment_message: 'The items in your cart are now {DISCOUNT} off. Text BUY to buy them now at {PRICE}!',
        follow_up_message: 'Your cart is still {DISCOUNT} off and is still in your cart. Reply with BUY to buy them now at {PRICE}!',
        confirmation_message: 'Your {PRICE} order is on the way! Your order number is {ORDERNUMBER}',
        number_of_times_to_message: 3,
        time_interval_between_messages: 72,
        invalid_message_response: 'Invalid command. Please reply with BUY to clear your cart or NO to cancel the order.',
        opt_in_invalid_message_response: 'Invalid command. Please reply with your confirmation code to complete Opt In or text NO to cancel'
    }
  end

end
