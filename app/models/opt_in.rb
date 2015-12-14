class OptIn < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :subscription
  has_one :customer

  validates_presence_of :subscription_id, :customer_id, :completed
end
