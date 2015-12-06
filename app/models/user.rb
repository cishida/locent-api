class User < ActiveRecord::Base
  acts_as_paranoid
  validates_uniqueness_of :auth_token
  before_create :generate_authentication_token!

  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :trackable, :validatable, :confirmable

  has_one :organisation


  def generate_authentication_token!
    begin
      self.auth_token = Devise.friendly_token
    end while self.class.exists?(auth_token: auth_token)
  end

end
