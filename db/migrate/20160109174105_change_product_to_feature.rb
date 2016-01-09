class ChangeProductToFeature < ActiveRecord::Migration
  def change
    rename_table :products, :features
    rename_column :opt_ins, :product_id, :feature_id
    rename_column :subscriptions, :product_id, :feature_id
  end
end
