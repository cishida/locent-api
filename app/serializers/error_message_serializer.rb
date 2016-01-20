class ErrorMessageSerializer < ActiveModel::Serializer
  has_one :error
  attributes :message
end