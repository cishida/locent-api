class CreateOrganisations < ActiveRecord::Migration
  def change
    create_table :organisations do |t|
      t.string :organisation_name
      t.integer :primary_user
      t.string :email
      t.string :client_key
      t.string :phone

      t.timestamps null: false
    end
  end
end
