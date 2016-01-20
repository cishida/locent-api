class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :email, :organization_name, :phone

  has_one :primary_user
  has_many :subscriptions
  has_many :error_messages
end
