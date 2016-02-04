class AddStatusToShortcodeApplication < ActiveRecord::Migration
  def change
    add_column :shortcode_applications, :status, :string
  end
end
