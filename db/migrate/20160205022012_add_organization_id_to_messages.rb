class AddOrganizationIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :organization_id, :integer
  end
end
