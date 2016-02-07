class OrderSerializer < ActiveModel::Serializer
  attributes :uid, :description, :price, :status, :created_at

  has_one :customer
end
