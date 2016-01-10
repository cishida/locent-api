class ChangeHasItemsToHasProducts < ActiveRecord::Migration
  def change
    rename_column :features, :has_items, :has_products
  end
end