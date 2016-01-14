class ChangeSafetextToOrders < ActiveRecord::Migration
  def change
    rename_table :safetexts, :orders
    rename_column :orders, :order_uid, :uid
    add_column :orders, :feature, :string
  end
end
