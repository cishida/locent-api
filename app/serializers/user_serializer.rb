class UserSerializer < ActiveModel::Serializer
  attributes :id, :first_name, :last_name, :email, :organization_id, :admin
end
