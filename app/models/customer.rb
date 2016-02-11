# @restful_api 1.0
#
# @property [String] first_name First Name of the customer
# @property [String] last_name Last Name of the customer
# @property [String] phone Phone Number of the customer
#
# @example
#   ```json
#   {
#     "first_name": "Jon",
#     "last_name": "Snow",
#     "phone": "+12025550197"
#   }
#   ```

class Customer < ActiveRecord::Base
  acts_as_paranoid

  belongs_to :organization

  has_many :opt_ins, dependent: :destroy

  validates_uniqueness_of :organization_id, :scope => :phone
  validates_uniqueness_of :organization_id, :scope => :uid

end
