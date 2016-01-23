class AddPercentageDiscountToOrder < ActiveRecord::Migration
  def change
    add_column :orders, :percentage_discount, :integer
  end
end
