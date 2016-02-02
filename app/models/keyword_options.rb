class KeywordOptions < ActiveRecord::Base
  acts_as_paranoid
  has_one  :subscription, as: :options, dependent: :destroy

  validates :opt_in_verification_url, :url => {:no_local => true}
  validates :opt_in_confirmation_url, :url => {:no_local => true}
  validates :purchase_request_url, :url => {:no_local => true}

  def self.defaults
    default_hash = {
        opt_in_message: 'Text your confirmation code to complete opt-in to Keyword or text NO to cancel.',
        opt_in_refusal_message: 'You have successfully cancelled opt-in to Keyword.',
        welcome_message: 'Welcome to Keyword. You can now buy items by sending us a text with only a keyword.',
        transactional_message: 'You just placed an order for {ITEM}. Your order is processing and we will send you a confirmation SMS soon.',
        confirmation_message: 'Your {PRICE} order for {ITEM} is on the way! Your order number is {ORDERNUMBER}.',
        cancellation_message: 'Your order for {ITEM} has been cancelled due to {ERROR}',
        opt_in_invalid_message: 'Invalid command. Please reply with your confirmation code to complete Opt In or text NO to cancel'
    }
  end
end
