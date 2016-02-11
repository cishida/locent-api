class AddIndexesOnForeignKeysToSpeedUpQueries < ActiveRecord::Migration
  def change
    add_index :messages, [:purpose_id, :purpose_type]
    add_index :campaigns, :organization_id
    add_index :subscriptions, [:options_id, :options_type]
    add_index :customers, :organization_id
    add_index :error_messages, :error_id
    add_index :error_messages, :organization_id
    add_index :opt_ins, :subscription_id
    add_index :opt_ins, :customer_id
    add_index :opt_ins, :feature_id
    add_index :orders, :opt_in_id
    add_index :orders, :organization_id
    add_index :products, :subscription_id
    add_index :products, :organization_id
    add_index :reminders, :order_id
    add_index :shortcode_applications, :organization_id
    add_index :subscriptions, :organization_id
    add_index :subscriptions, :feature_id
    add_index :users, :organization_id

  end
end
