class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name
      t.boolean :has_items, default: false

      t.timestamps null: false
    end
  end
end
