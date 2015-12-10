class Organization < ActiveRecord::Base
  acts_as_paranoid
  before_create :set_auth_token
  has_many :users, dependent: :destroy
  has_one  :primary_user, -> { where(is_primary: true) }, :class_name => "User"
  has_many :subscriptions, dependent: :destroy
  has_many :products, through: :subscriptions, dependent: :destroy
  has_many :customers

  validates_presence_of :organization_name
  validates_uniqueness_of :organization_name


  private
  def set_auth_token
    return if auth_token.present?
    self.auth_token = generate_auth_token
  end

  def generate_auth_token
    SecureRandom.uuid.gsub(/\-/,'')
  end


end
