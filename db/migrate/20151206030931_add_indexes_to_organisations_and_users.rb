class AddIndexesToOrganisationsAndUsers < ActiveRecord::Migration
  def change
    add_index :users, :organisation_id
    add_index :organisations, :primary_user_id
  end
end
