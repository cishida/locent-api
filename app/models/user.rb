class User < ParanoidModel
  include DeviseTokenAuth::Concerns::User
  acts_as_paranoid
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable

end
