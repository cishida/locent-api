# @restful_api 1.0
#
# @property [String] kind Type of campaign
# @property [Integer] number_of_targets
# @property [String] name Campaign name
# @property [String] message
#
# @example
#   ```json
#   {
#     "kind": "alerts",
#     "number_of_targets": "200",
#     "name": "75% OFF PROMO",
#     "message": "Hey, you get 75% off..."
#   }
#   ```
class Campaign < ActiveRecord::Base
  acts_as_paranoid
  has_many  :messages, as: :purpose, dependent: :destroy
  belongs_to :organization

end
