class CreateCampaigns < ActiveRecord::Migration
  def change
    create_table :campaigns do |t|
      t.string :kind
      t.integer :number_of_targets

      t.timestamps null: false
    end
  end
end
