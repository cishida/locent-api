class ChangeProductColumns < ActiveRecord::Migration
  def change
    rename_column :products, :product_name, :name
    rename_column :products, :product_uid, :uid
    change_column :products, :uid, :string
  end
end
