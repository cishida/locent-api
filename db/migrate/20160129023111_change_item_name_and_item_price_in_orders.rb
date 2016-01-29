class ChangeItemNameAndItemPriceInOrders < ActiveRecord::Migration
  def change
    rename_column :orders, :item_price, :price
    rename_column :orders, :item_name, :description
  end
end
