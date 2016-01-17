class OrdersSerializer < ActiveModel::Serializer
  attributes :uid, :item_name, :item_price, :status

  has_one :customer
  
end
