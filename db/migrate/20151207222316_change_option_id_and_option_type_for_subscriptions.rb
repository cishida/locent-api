class ChangeOptionIdAndOptionTypeForSubscriptions < ActiveRecord::Migration
  def change
    rename_column :subscriptions, :option_id, :options_id
    rename_column :subscriptions, :option_type, :options_type
    rename_column :clearcart_options, :intial_cart_abandonment_message, :initial_cart_abandonment_message
  end
end
