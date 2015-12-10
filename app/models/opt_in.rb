class OptIn < ActiveRecord::Base
  acts_as_paranoid

  validates_presence_of :subscription_id, :customer_id, :completed
end
