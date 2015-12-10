class AddUrlsToKeywordOptions < ActiveRecord::Migration
  def change
    add_column :keyword_options, :opt_in_verification_url, :string
    add_column :keyword_options, :opt_in_confirmation_url, :string
    add_column :keyword_options, :purchase_request_url, :string
  end
end
