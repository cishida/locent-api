class ChangeAllInvalidMessageToInvalidMessageResponse < ActiveRecord::Migration
  def change
    rename_column :safetext_options, :invalid_message, :invalid_message_response
    rename_column :clearcart_options, :invalid_message, :invalid_message_response
    rename_column :keyword_options, :opt_in_invalid_message, :opt_in_invalid_message_response
    rename_column :safetext_options, :opt_in_invalid_message, :opt_in_invalid_message_response
    rename_column :clearcart_options, :opt_in_invalid_message, :opt_in_invalid_message_response
  end
end
