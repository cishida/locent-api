class User < ActiveRecord::Base
  include DeviseTokenAuth::Concerns::User
  belongs_to :organization
  acts_as_paranoid
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

end
