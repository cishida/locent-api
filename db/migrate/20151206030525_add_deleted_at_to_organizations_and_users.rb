class AddDeletedAtToOrganizationsAndUsers < ActiveRecord::Migration
  def change
    add_column :organizations, :deleted_at, :datetime
    add_index :organizations, :deleted_at

    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at
  end
end
