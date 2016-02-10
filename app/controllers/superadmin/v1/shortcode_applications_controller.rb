# @restful_api 1.0
#
# Superadmin::ShortcodeApplications
#
class Superadmin::V1::ShortcodeApplicationsController < SuperAdminController
  before_action :authenticate_super_admin

  # @url /superadmin/shortcode_applications
  # @action GET
  #
  # Gets paginated list of all shortcode application
  #
  # @response_field [Array<ShortcodeApplications>] applications All shortcode applications
  #
  def index
    @applications = ShortcodeApplication.all
    paginate json: @applications
  end

  # @url /superadmin/shortcode_applications/:id/update_status
  # @action PUT
  #
  # Updates status of shortcode application
  #
  # @required [Integer] id The application id.
  # @required [String] status The application status. It could be "pending", "approved" or "rejected".
  #
  # @response_field [ShortcodeApplication] application The updated application
  #
  def update_status
    param! :status, String, required: true

    @application = ShortcodeApplication.find(params[:id])
    if @application.update(status: params[:status])
      render json: @application, status: 201
    else
      render json: {errors: @application.full_messages}, status: 422
    end
  end

  # @url /superadmin/shortcode_applications/:id/assign_shortcode_to_organization
  # @action POST
  #
  # Assign a shortcode to an organization
  #
  # @required [Integer] id The organization id.
  # @required [String] shortcode The shortcode.
  #
  # @response_field [Organization] organization The updated organization
  #
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