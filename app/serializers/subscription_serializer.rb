class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :organisation_id, :product_id, :short_code, :option_id, :option_type
end
