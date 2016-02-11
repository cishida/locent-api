# @restful_api 1.0
#
# @property [String] uid
# @property [String] description Order description, could be the item name or a description of a customer's cart
# @property [String] price
# @property [String] status Can be 'successful', 'failed', 'pending', 'awaiting customer confirmation'
# @property [DateTime] created_at
#
# @example
#   ```json
#   {
#     "uid": "xxxx-3e333s0xxee0x"
#     "decription": "iPhone 6 (64GB)",
#     "price": "749.99",
#     "status": "pending",
#     "created_at": "...",
#   }
#   ```
class Order < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :opt_in
  belongs_to :organization
  has_one :customer, through: :opt_in
  has_one :reminder
  has_many  :messages, as: :purpose, dependent: :destroy

  validates_uniqueness_of :organization_id, :scope => :uid
  before_save :set_status


  def set_status
    if self.order_success && self.completed
      self.status = 'successful'
    elsif self.completed && !self.order_success
      self.status = 'failed'
    elsif !self.completed && !self.confirmed
      self.status = 'awaiting customer confirmation'
    elsif !self.completed && self.confirmed
      self.status = 'pending'
    end

    set_reminder_status
  end

  def set_reminder_status
    if !self.reminder.blank? && (self.status == 'successful' || self.status = 'failed')
      self.reminder.active = false
    end
  end
end


Message.all.each do |x|
  if Organization.exists?(long_number: x.to)
    x.update(organization_id: Organization.find_by_long_number(x.to).id)
  end
end