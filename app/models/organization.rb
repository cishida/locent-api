class Organization < ActiveRecord::Base
  acts_as_paranoid

  before_create :set_auth_token
  has_many :users, dependent: :destroy
  has_one :primary_user, -> { where(is_primary: true) }, :class_name => "User"
  has_many :features, through: :subscriptions
  has_many :subscriptions, dependent: :destroy
  has_many :customers
  has_many :orders

  validates_presence_of :organization_name
  validates_uniqueness_of :organization_name


  def from
    if self.short_code.nil?
      return self.long_number
    else
      return self.short_code
    end
  end

  private
  def set_auth_token
    return if auth_token.present?
    self.auth_token = generate_auth_token
  end

  def generate_auth_token
    SecureRandom.uuid.gsub(/\-/, '')
  end

end
