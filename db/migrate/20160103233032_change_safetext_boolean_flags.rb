class ChangeSafetextBooleanFlags < ActiveRecord::Migration
  def change
    add_column :safetexts, :order_success, :boolean
  end
end
