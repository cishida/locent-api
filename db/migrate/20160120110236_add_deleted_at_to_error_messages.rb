class AddDeletedAtToErrorMessages < ActiveRecord::Migration
  def change
    add_column :error_messages, :deleted_at, :datetime
    add_index :error_messages, :deleted_at
  end
end
