class AddDeletedAtToOptInAndCustomer < ActiveRecord::Migration
  def change
    add_column :opt_ins, :deleted_at, :datetime
    add_column :customers, :deleted_at, :datetime
    add_index :opt_ins, :deleted_at
    add_index :customers, :deleted_at
  end
end
