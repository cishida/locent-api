class AddInvalidMessageResponseToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :customer_invalid_message_response, :text
    add_column :organizations, :stranger_invalid_message_response, :text
  end
end
