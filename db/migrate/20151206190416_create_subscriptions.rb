class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.integer :organization_id
      t.integer :product_id
      t.integer :short_code
      t.string :option_id
      t.string :option_type

      t.timestamps null: false
    end
  end
end
