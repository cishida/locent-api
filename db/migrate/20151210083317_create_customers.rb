class CreateCustomers < ActiveRecord::Migration
  def change
    create_table :customers do |t|
      t.integer :organisation_id
      t.string :phone
      t.string :first_name
      t.string :last_name

      t.timestamps null: false
    end
  end
end
