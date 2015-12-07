class SafetextOptionsSerializer < ActiveModel::Serializer
  attributes :id, :opt_in_message,
             :opt_in_refusal_message,
             :welcome_message,
             :transactional_message,
             :cancellation_message,
             :confirmation_message,
end
