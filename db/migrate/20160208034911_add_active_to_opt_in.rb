class AddActiveToOptIn < ActiveRecord::Migration
  def change
    add_column :opt_ins, :active, :boolean, default: true
  end
end
