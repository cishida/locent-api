class RemoveIndexOnCustomerUid < ActiveRecord::Migration
  def change
    remove_index :customers, :uid
  end
end
