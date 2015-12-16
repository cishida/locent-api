class OptIn < ActiveRecord::Base
  acts_as_paranoid
  before_create :set_verification_code
  belongs_to :subscription
  has_one :customer

  validates_presence_of :subscription_id, :customer_id, :completed


  private
  def set_verification_code
    return if verification_code.present?
    self.verification_code = generate_verification_code
  end

  def generate_verification_code
    SecureRandom.hex(5).upcase
  end
end
