class CreateOrganizations < ActiveRecord::Migration
  def change
    create_table :organizations do |t|
      t.string :organization_name
      t.integer :primary_user
      t.string :email
      t.string :client_key
      t.string :phone

      t.timestamps null: false
    end
  end
end
