class OrganizationSerializer < ActiveModel::Serializer
  attributes :id, :email, :organization_name, :phone, :auth_token

  has_one :primary_user
end
