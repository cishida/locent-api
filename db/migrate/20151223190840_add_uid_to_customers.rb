class AddUidToCustomers < ActiveRecord::Migration
  def change
    add_column :customers, :uid, :string
    add_index :customers, :uid, :unique => true
  end
end
