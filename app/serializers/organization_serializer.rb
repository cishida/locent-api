class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :email, :organization_name, :phone, :customer_invalid_message_response, :stranger_invalid_message_response, :long_number, :short_code, :auth_token

  has_one :primary_user
  has_many :subscriptions
  has_many :error_messages
end
