class ChangeItemPriceToDecimalInOrders < ActiveRecord::Migration
  def change
    change_column :orders, :item_price, 'decimal USING item_price::numeric'
  end
end
