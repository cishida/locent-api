class SafetextOptions < ActiveRecord::Base
  acts_as_paranoid
  has_one  :subscription, as: :options, dependent: :destroy

  validates :opt_in_verification_url, :url => {:no_local => true}
  validates :opt_in_confirmation_url, :url => {:no_local => true}
  validates :purchase_request_url, :url => {:no_local => true}


  def self.defaults
    default_hash = {
        opt_in_message: 'Text your confirmation code to complete opt-in to Safetext or text NO to cancel.',
        opt_in_refusal_message: 'You have successfully cancelled opt-in to Safetext.',
        welcome_message: 'Welcome to Safetext. You will receive an SMS to confirm every purchase that is attempted with your account',
        transactional_message: 'A {PRICE} order for {ITEM} has been placed with your account. Reply PAY to confirm order or NO to cancel',
        cancellation_message: 'You have cancelled the {PRICE} order for {ITEM}',
        confirmation_message: 'Your {PRICE} order for {ITEM} is on the way! Your order number is {ORDERNUMBER}',
        invalid_message_response: 'Invalid command. Please reply with PAY to complete your order or NO to cancel it.',
        opt_in_invalid_message_response: 'Invalid command. Please reply with your confirmation code to complete Opt In or text NO to cancel'
    }
  end
end
