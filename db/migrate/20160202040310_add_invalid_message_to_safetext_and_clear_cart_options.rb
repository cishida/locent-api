class AddInvalidMessageToSafetextAndClearCartOptions < ActiveRecord::Migration
  def change
    add_column :safetext_options, :invalid_message, :text
    add_column :clearcart_options, :invalid_message, :text
  end
end
