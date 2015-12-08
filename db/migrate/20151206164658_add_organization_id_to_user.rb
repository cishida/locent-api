class AddOrganizationIdToUser < ActiveRecord::Migration
  def change
    add_column :users, :organization_id, :integer
    add_column :users, :is_primary, :boolean, default: false
  end
end
