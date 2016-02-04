class Superadmin::V1::ShortcodeApplicationsController < SuperAdminController
  before_action :authenticate_super_admin

  def index
    @applications = ShortcodeApplication.all
    paginate json: @applications
  end

  def update_status
    param! :status, String, required: true

    @application = ShortcodeApplication.find(params[:id])
    if @application.update(status: params[:status])
      render json: @application, status: 201
    else
      render json: {errors: @application.full_messages}, status: 422
    end
  end

  def assign_shortcode_to_organization
    param! :shortcode, String, required: true

    @organization = Organization.find(params[:id])
    if @organization.update(short_code: params[:shortcode])
      render json: @organization, status: 201
    else
      render json: {errors: @organization.full_messages}, status: 422
    end
  end
end