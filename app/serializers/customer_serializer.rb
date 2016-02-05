class CustomerSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name, :phone, :uid

end