class RemoveSubscriptionIdFromCustomer < ActiveRecord::Migration
  def change
    remove_column :customers, :subscription_id
  end
end
