class AddOrganizationIdToShorcCodeApplication < ActiveRecord::Migration
  def change
    add_column :shortcode_applications, :organization_id, :integer
  end
end
