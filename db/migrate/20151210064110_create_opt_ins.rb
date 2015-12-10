class CreateOptIns < ActiveRecord::Migration
  def change
    create_table :opt_ins do |t|
      t.integer :subscription_id
      t.integer :customer_id

      t.timestamps null: false
    end
  end
end
