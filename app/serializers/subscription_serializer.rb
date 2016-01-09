class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :organization_id, :feature_id, :short_code, :options_id, :options_type
end
