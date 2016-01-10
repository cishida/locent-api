class CreateKeywordProducts < ActiveRecord::Migration
  def change
    create_table :keyword_products do |t|
      t.string :product_name
      t.string :product_uid
      t.integer :subscription_id
      t.string :keyword
      t.decimal :price

      t.timestamps null: false
    end
  end
end
