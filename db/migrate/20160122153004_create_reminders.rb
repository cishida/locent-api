class CreateReminders < ActiveRecord::Migration
  def change
    create_table :reminders do |t|
      t.integer :number_of_times
      t.integer :order_id
      t.integer :interval
      t.boolean :active, default: true

      t.timestamps null: false
    end
  end
end
