class AddFieldsToShortcodeApplication < ActiveRecord::Migration
  def change
    add_column :shortcode_applications, :vanity_or_random, :string
    add_column :shortcode_applications, :payment_frequency, :string


    add_column :shortcode_applications, :company_name, :string
    add_column :shortcode_applications, :company_mailing_address, :text
    add_column :shortcode_applications, :city, :string
    add_column :shortcode_applications, :state_or_province, :string
    add_column :shortcode_applications, :primary_contact_name, :string
    add_column :shortcode_applications, :primary_contact_number, :string
    add_column :shortcode_applications, :support_email_address, :string
    add_column :shortcode_applications, :support_toll_free_number, :string
    add_column :shortcode_applications, :company_tax_id, :string
    add_column :shortcode_applications, :company_email, :string

    add_column :shortcode_applications, :help_message, :string
    add_column :shortcode_applications, :stop_message, :string


  end
end
