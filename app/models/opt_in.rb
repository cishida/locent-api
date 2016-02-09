class OptIn < ActiveRecord::Base
  acts_as_paranoid
  default_scope { where(active: true) }

  before_create :set_verification_code

  belongs_to :subscription
  belongs_to :customer
  belongs_to :feature
  has_many :orders
  has_many  :messages, as: :purpose, dependent: :destroy


  validates_presence_of :subscription_id, :customer_id
  validates_uniqueness_of :subscription_id, :scope => :customer_id

  private
  def set_verification_code
    return if verification_code.present?
    self.verification_code = generate_verification_code
  end

  def generate_verification_code
    SecureRandom.hex(3).upcase
  end

end
