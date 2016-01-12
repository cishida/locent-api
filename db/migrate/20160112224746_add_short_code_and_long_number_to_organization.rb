class AddShortCodeAndLongNumberToOrganization < ActiveRecord::Migration
  def change
    add_column :organizations, :short_code, :string
    add_column :organizations, :long_number, :string
  end
end
