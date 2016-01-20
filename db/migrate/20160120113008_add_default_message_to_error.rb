class AddDefaultMessageToError < ActiveRecord::Migration
  def change
    add_column :errors, :default_message, :text
  end
end
