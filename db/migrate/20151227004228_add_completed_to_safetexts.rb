class AddCompletedToSafetexts < ActiveRecord::Migration
  def change
    add_column :safetexts, :completed, :boolean, default: false
  end
end
