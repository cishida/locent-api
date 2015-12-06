class ProductSerializer < ActiveModel::Serializer
  attributes :id, :name, :has_items
end
