class CreateShortcodeApplications < ActiveRecord::Migration
  def change
    create_table :shortcode_applications do |t|
      t.timestamps null: false
    end
  end
end
