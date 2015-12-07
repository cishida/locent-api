class CreateClearCartOptions < ActiveRecord::Migration
  def change
    create_table :clearcart_options do |t|
          t.text :opt_in_message
          t.text :opt_in_refusal_message
          t.text :welcome_message
          t.text :intial_cart_abandonment_message
          t.text :follow_up_message
          t.text :cancellation_message
          t.text :confirmation_message
          t.integer :number_of_times_to_message
          t.integer :time_interval_between_messages
          t.datetime :deleted_at

          t.timestamps null: false
    end
  end
end
