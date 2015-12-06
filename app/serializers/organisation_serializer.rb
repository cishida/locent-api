class OrganisationSerializer < ActiveModel::Serializer
  attributes :id, :email, :organisation_name, :phone

  has_one :primary_user
end
