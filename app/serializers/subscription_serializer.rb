class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :organization_id, :feature_id, :options_id, :options_type
end
