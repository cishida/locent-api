class User < ActiveRecord::Base
  include DeviseTokenAuth::Concerns::User
  acts_as_paranoid
  belongs_to :organization

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

  def is_admin?
    return self.admin
  end

end
