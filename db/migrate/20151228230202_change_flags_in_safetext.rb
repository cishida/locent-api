class ChangeFlagsInSafetext < ActiveRecord::Migration
  def change
    add_column :safetexts, :confirmed, :boolean, default: false
  end
end
