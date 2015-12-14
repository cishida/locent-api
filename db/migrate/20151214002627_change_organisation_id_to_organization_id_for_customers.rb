class ChangeOrganisationIdToOrganizationIdForCustomers < ActiveRecord::Migration
  def change
    rename_column :customers, :organisation_id, :organization_id
  end
end
