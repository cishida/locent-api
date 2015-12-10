class KeywordOptionsSerializer < ActiveModel::Serializer
  attributes :id, :opt_in_message, :opt_in_refusal_message, :welcome_message,
             :transactional_message, :confirmation_message, :cancellation_message,
             :opt_in_verification_url, :opt_in_confirmation_url, :purchase_request_url
end
