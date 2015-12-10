class ClearcartOptionsSerializer < ActiveModel::Serializer
  attributes :id, :opt_in_message,
             :opt_in_refusal_message,
             :welcome_message,
             :initial_cart_abandonment_message,
             :follow_up_message,
             :confirmation_message,
             :number_of_times_to_message,
             :time_interval_between_messages,
             :opt_in_verification_url, :opt_in_confirmation_url, :purchase_request_url

end
