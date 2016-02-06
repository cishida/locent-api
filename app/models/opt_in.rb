class OptIn < ActiveRecord::Base
  acts_as_paranoid
  before_create :set_verification_code

  belongs_to :subscription
  belongs_to :customer
  belongs_to :feature
  has_many :orders
  has_many  :messages, as: :purpose, dependent: :destroy


  validates_presence_of :subscription_id, :customer_id
  validates_uniqueness_of :subscription_id, :scope => :customer_id

  def has_at_least_one_successful_order?
    self.orders.each do |order|
      if order.completed && order.status == "successful"
        return true
      end
    end
    return false
  end

  private
  def set_verification_code
    return if verification_code.present?
    self.verification_code = generate_verification_code
  end

  def generate_verification_code
    SecureRandom.hex(3).upcase
  end

end
