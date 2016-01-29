class MessagesSerializer < ActiveModel::Serializer
  attributes :body, :kind, :status, :created_at

end