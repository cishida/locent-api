# @restful_api 1.0
#
# @property [Integer] id ID of the feature
# @property [String] name Name of the feature
# @property [Boolean] has_products this is `true` when the feature can have products added to it. Example: Keyword
#
# @example
#   ```json
#   {
#     "id": "1",
#     "name": "Keyword",
#     "has_products": "true"
#   }
#   ```
class Feature < ActiveRecord::Base
  acts_as_paranoid

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :organizations, through: :subscriptions
  has_many :subscriptions, dependent: :destroy
  has_many :opt_ins, dependent: :destroy
end
