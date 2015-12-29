class AddProductIdToOptIn < ActiveRecord::Migration
  def change
    add_column :opt_ins, :product_id, :integer
  end
end
