class Order < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :opt_in
  belongs_to :organization
  has_one :customer, through: :opt_in
  has_one :reminder
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
    if self.status == 'successful' || self.status = 'failed'
      self.reminder.active = false
    end
  end
end
