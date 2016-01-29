class OrdersSerializer < ActiveModel::Serializer
  attributes :uid, :description, :price, :status

  has_one :customer
  
end
