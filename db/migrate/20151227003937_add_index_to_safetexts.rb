class AddIndexToSafetexts < ActiveRecord::Migration
  def change
    add_index :safetexts, :deleted_at
  end
end
