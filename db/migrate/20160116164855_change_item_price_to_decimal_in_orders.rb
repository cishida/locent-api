class ChangeItemPriceToDecimalInOrders < ActiveRecord::Migration
  def change
    change_column :orders, :item_price, :decimal
  end
end
