class CreateErrorMessages < ActiveRecord::Migration
  def change
    create_table :error_messages do |t|
      t.integer :error_id
      t.text :message
      t.integer :organization_id
      t.timestamps null: false
    end
  end
end
