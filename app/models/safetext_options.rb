class SafetextOptions < ActiveRecord::Base
  acts_as_paranoid
  has_one  :subscription, as: :options, dependent: :destroy

  def self.defaults
    default_hash = {
        opt_in_message: 'Text your confirmation code to complete opt-in to Safetext or text NO to cancel.',
        opt_in_refusal_message: 'You have successfully cancelled opt-in to Safetext.',
        welcome_message: 'Welcome to Safetext. You will receive an SMS to confirm every purchase that is attempted with your account',
        transactional_message: 'An {PRICE} order for {ITEM} has been placed with your account. Reply YES to confirm order or NO to cancel',
        cancellation_message: 'You have cancelled the {PRICE} order for {ITEM}',
        confirmation_message: 'Your {PRICE} order for {ITEM} is on the way! Your order number is {ORDERNUMBER}',
    }
  end
end
