class AddIsPrimaryToUserAndRemovePrimaryUserIdFromOrganization < ActiveRecord::Migration
  def change
    add_column :users, :is_primary, :boolean, default: false;
    remove_column :organizations, :primary_user_id
  end
end
