class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :email, :organization_name, :phone, :customer_invalid_message_response, :stranger_invalid_message_response

  has_one :primary_user
  has_many :subscriptions
  has_many :error_messages
end
