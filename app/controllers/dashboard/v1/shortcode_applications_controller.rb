# @restful_api 1.0
#
# ShortcodeApplications
#
class Dashboard::V1::ShortcodeApplicationsController < DashboardController

  # @url /dashboard/shortcode_applications
  # @action POST
  #
  # Submits organization's shorcode application
  #
  # @required [String] vanity_or_random The type of shortcode e.g 'vanity'
  # @required [String] payment_frequency The frequency of payment e.g "$3000/quarter"
  # @required [String] company_name The name of the company
  # @required [String] company_mailing_address The company's mailing address
  # @required [String] city The company's city
  # @required [String] state_or_province The company's province
  # @required [String] primary_contact_name
  # @required [String] primary_contact_number
  # @required [String] support_email_address
  # @required [String] support_toll_free_number
  #
  # @response_field [ShortcodeApplication] application The newly created/submitted application
  def create
    validate_shortcode_application_params
    @application = ShortcodeApplication.new(params)
    @application.organization = current_user.organization
    if @application.save
      render json: @application, status: 201
    else
      render json: {errors: @application.full_messages}, status: 422
    end
  end


  private

  def validate_shortcode_application_params
    param! :vanity_or_random, String, required: true
    param! :payment_frequency, String, required: true
    param! :company_name, String, required: true
    param! :company_mailing_address, String, required: true
    param! :city, String, required: true
    param! :state_or_province, String, required: true
    param! :primary_contact_name, String, required: true
    param! :primary_contact_number, String, required: true
    param! :support_email_address, String, required: true
    param! :support_toll_free_number, String, required: true
  end

end