class CreateSafeTextOptions < ActiveRecord::Migration
  def change
    create_table :safetext_options do |t|
          t.text :opt_in_message
          t.text :opt_in_refusal_message
          t.text :welcome_message
          t.text :transactional_message
          t.text :cancellation_message
          t.text :confirmation_message
          t.datetime :deleted_at

      t.timestamps null: false
    end
  end
end
