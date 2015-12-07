class AddDeletedAtToProductsSubscriptionsAndKeyWordOptions < ActiveRecord::Migration
  def change
    add_column :products, :deleted_at, :datetime
    add_index :products, :deleted_at

    add_column :subscriptions, :deleted_at, :datetime
    add_index :subscriptions, :deleted_at

    add_column :keyword_options, :deleted_at, :datetime
    add_index :keyword_options, :deleted_at
  end
end
