class AddOrganizationIdToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :organization_id, :integer
  end
end
