class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :organization_id, :product_id, :short_code, :options_id, :options_type
end
