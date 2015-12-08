class AddIndexesToOrganizationsAndUsers < ActiveRecord::Migration
  def change
    add_index :users, :organization_id
    add_index :organizations, :primary_user_id
  end
end
