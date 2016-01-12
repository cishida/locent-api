class RemoveShortCodeFromSubscriptions < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :short_code
  end
end
