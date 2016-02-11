# @restful_api 1.0
#
# @property [String] body First Name of the customer
# @property [String] kind Can be "incoming" or "outgoing"
# @property [String] status
# @property [DateTime] created_at
#
# @example
#   ```json
#   {
#     "body": "Text YES to purchase",
#     "kind": "outgoign",
#     "status": "delivered",
#     "created_at": "..."
#   }
#   ```
class Message < ActiveRecord::Base
  acts_as_paranoid
  belongs_to :purpose, polymorphic: :true, dependent: :destroy


  def purpose_feature
    if self.purpose.is_a? Order
      return self.purpose.feature
    elsif self.purpose.is_a? OptIn
      return self.purpose.feature.name
    end
  end
end
