class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :uid, :price, :keyword
end