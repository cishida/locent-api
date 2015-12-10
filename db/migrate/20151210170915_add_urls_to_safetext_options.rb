class AddUrlsToSafetextOptions < ActiveRecord::Migration
  def change
    add_column :safetext_options, :opt_in_verification_url, :string
    add_column :safetext_options, :opt_in_confirmation_url, :string
    add_column :safetext_options, :purchase_request_url, :string
  end
end
