class AddSubscriptionIdToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :subscription_id, :integer
  end
end
