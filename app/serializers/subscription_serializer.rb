class SubscriptionSerializer < ActiveModel::Serializer
  attributes :id, :organization_id, :feature_id, :options_id, :options_type, :are_options_urls_complete?
end
