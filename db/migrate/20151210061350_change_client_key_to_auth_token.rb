class ChangeClientKeyToAuthToken < ActiveRecord::Migration
  def change
    rename_column :organizations, :client_key, :auth_token
  end
end
