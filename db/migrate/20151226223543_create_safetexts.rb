class CreateSafetexts < ActiveRecord::Migration
  def change
    create_table :safetexts do |t|
      t.string :order_uid
      t.string :item_name
      t.string :item_price
      t.integer :opt_in_id
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
