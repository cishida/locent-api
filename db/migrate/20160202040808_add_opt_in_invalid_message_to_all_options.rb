class AddOptInInvalidMessageToAllOptions < ActiveRecord::Migration
  def change
    add_column :keyword_options, :opt_in_invalid_message, :text
    add_column :safetext_options, :opt_in_invalid_message, :text
    add_column :clearcart_options, :opt_in_invalid_message, :text
  end
end
