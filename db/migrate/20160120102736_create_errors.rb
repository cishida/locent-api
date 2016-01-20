class CreateErrors < ActiveRecord::Migration
  def change
    create_table :errors do |t|
      t.integer :code
      t.string :description



      t.timestamps null: false
    end
  end
end
