class ErrorSerializer < ActiveModel::Serializer
  attributes :code, :description, :default_message
end