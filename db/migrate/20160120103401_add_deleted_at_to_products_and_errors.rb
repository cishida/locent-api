class AddDeletedAtToProductsAndErrors < ActiveRecord::Migration
  def change
    add_column :products, :deleted_at, :datetime
    add_column :errors, :deleted_at, :datetime
    add_index :products, :deleted_at
    add_index :errors, :deleted_at
  end
end
