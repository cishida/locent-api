class AddPurposeTypeAndPurposeIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :purpose_id, :integer
    add_column :messages, :purpose_type, :string
  end
end
