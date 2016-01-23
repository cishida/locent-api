class AddLastSentToReminder < ActiveRecord::Migration
  def change
    add_column :reminders, :last_sent, :datetime
  end
end
