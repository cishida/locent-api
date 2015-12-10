class AddCompletedToOptIn < ActiveRecord::Migration
  def change
    add_column :opt_ins, :completed, :boolean, default: false
  end
end
