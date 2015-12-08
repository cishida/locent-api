class ChangePrimaryUserToPrimaryUserId < ActiveRecord::Migration
  def change
    rename_column :organizations, :primary_user, :primary_user_id
  end
end
