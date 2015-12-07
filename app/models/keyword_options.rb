class KeywordOptions < ActiveRecord::Base
  acts_as_paranoid
  has_one  :subscription, as: :option, dependent: :destroy


  def self.defaults
    default_hash = {
        opt_in_message: 'Text YES to complete opt-in to Keyword or NO to cancel opt-in.',
        opt_in_refusal_message: 'You have successfully cancelled opt-in to Keyword.',
        welcome_message: 'Welcome to Keyword. You can now buy items by sending us a text with only a keyword.',
        transactional_message: 'You just placed an order for {ITEM}. Your order is processing and we will send you a confirmation SMS soon.',
        confirmation_message: 'Your {PRICE} order for {ITEM} is on the way! Your order number is {ORDERNUMBER}.',
        cancellation_message: 'Your order for {ITEM} has been cancelled due to {ERROR}',
    }
  end
end
