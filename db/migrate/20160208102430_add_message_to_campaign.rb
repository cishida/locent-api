class AddMessageToCampaign < ActiveRecord::Migration
  def change
    add_column :campaigns, :message, :text
  end
end
