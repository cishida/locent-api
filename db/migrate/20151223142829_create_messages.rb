class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :sid
      t.string :status
      t.string :to
      t.string :body

      t.timestamps null: false
    end
  end
end
