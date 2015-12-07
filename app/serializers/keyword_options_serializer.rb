class KeywordOptionsSerializer < ActiveModel::Serializer
  attributes :id, :opt_in_message, :opt_in_refusal_message, :welcome_message,
             :transactional_message, :confirmation_message, :cancellation_message
end
