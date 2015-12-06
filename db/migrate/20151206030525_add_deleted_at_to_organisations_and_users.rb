class AddDeletedAtToOrganisationsAndUsers < ActiveRecord::Migration
  def change
    add_column :organisations, :deleted_at, :datetime
    add_index :organisations, :deleted_at

    add_column :users, :deleted_at, :datetime
    add_index :users, :deleted_at
  end
end
