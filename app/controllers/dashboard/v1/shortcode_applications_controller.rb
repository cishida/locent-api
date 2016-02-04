class Dashboard::V1::ShortcodeApplicationsController < DashboardController

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