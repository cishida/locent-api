# @restful_api 1.0
#
# @property [String] id
# @property [String] first_name
# @property [String] last_name
# @property [String] email
# @property [Integer] organization_id
# @property [Boolean] admin
#
# @example
#   ```json
#   {
#     "first_name": "Jon",
#     "last_name": "Snow",
#     "phone": "+12025550197",
#     "uid": "xxxx-3e333s0xxee0x"
#   }
#   ```
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
