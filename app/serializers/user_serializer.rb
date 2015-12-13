class UserSerializer < ActiveModel::Serializer
  attributes :id, :uid, :first_name, :last_name, :email, :organization_id
end
