class OrderSerializer < ActiveModel::Serializer
  attributes :uid, :description, :price, :status

  has_one :customer
end
