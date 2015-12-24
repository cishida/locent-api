class AddTypeToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :kind, :string
    add_column :messages, :from, :string
  end
end
