# @restful_api 1.0
#
# Organizations
#
class Dashboard::V1::OrganizationsController < DashboardController
  before_action :authenticate_user!, only: [:update, :users]
  before_action :set_organization, except: [:create]
  before_action :validate_create_params, only: :create
  before_action :validate_update_params, only: :update

  # @url /organizations
  # @action GET
  #
  # Get a list of all of Locent's organizations
  #
  # @response_field [Array<Organization>]
  def index
    respond_with Organization.all
  end

  # @url /organizations/:id
  # @action GET
  #
  # Gets one organization
  #
  # @required [Integer] id ID of the organization
  #
  # @response_field [Organization]
  def show
    respond_with Organization.find(params[:id])
  end

  def create
    ActiveRecord::Base.transaction do
      @organization = Organization.new(organization_params)
      if @organization.save && create_primary_user_account
        render json: @organization, status: 201
      else
        render json: {errors: combined_errors}, status: 422
        @user.really_destroy!
      end
    end
  end

  def update
    if @organization.update(organization_params)
      render json: @organization, status: 201
    else
      render json: {errors: @organization.errors.full_messages}, status: 422
    end
  end

  def update_error_message
    param! :message, String, required: true
    param! :code, String, required: true
    set_error
    set_error_message
    if @error_message.update(message: params[:message])
      head status: 201
    end
  end

  def users
    paginate json: @organization.users
  end

  def create_users
    ActiveRecord::Base.transaction do
      if current_user.is_admin?
        validate_create_users_params
        @users = []
        users_array = params[:users]
        users_array.each do |user|
          create_new_user(user)
        end
        paginate json: @users, status: 201
      else
        head status: :unauthorized
      end
    end
  end

  def update_user_admin_status
    param! :uid, String, required: true
    param! :admin, :boolean

    @user = User.find_by_uid(params[:uid])
    @user.update(admin: params[:admin])

    respond_with @user
  end

  def destroy_user
    param! :id, String, required: true
    @user = User.find(params[:id])
    @user.destroy
    head status: 204
  end

  private

  def set_organization
    @organization = current_user.organization
  end

  def set_error
    @error = Error.find_by_code(params[:code])
  end

  def set_error_message
    @error_message = ErrorMessage.find_by_error_id_and_organization_id(@error.id, @organization.id)
  end

  def create_primary_user_account
    @user = @organization.build_primary_user(organization_primary_user_params)
    @user.update(admin: true)
  end

  def combined_errors
    @user.errors.full_messages.each do |message|
      @organization.errors[:user] << (message)
    end
    return @organization.errors.full_messages
  end

  def validate_create_params
    param! :organization_name, String, required: true
    param! :email, String, required: true
    param! :phone, String, required: true
    param! :first_name, String, required: true
    param! :last_name, String, required: true
    param! :password, String, required: true
  end

  def validate_update_params
    param! :organization_name, String
    param! :email, String
    param! :phone, String
  end

  def validate_create_users_params
    param! :users, Array, required: true do |user|
      user.param! :first_name, String, required: true
      user.param! :last_name, String, required: true
      user.param! :email, String, required: true
      user.param! :password, String, required: true
      user.param! :admin, :boolean
    end
  end

  def create_new_user(user)
    @user = User.new(
        organization_id: @organization.id,
        first_name: user[:first_name],
        last_name: user[:last_name],
        email: user[:email],
        password: user[:password],
        admin: user[:admin]
    )
    if @user.save
      @users << @user
    end
  end

  def organization_params
    params.permit(:organization_name, :email, :phone, :customer_invalid_message_response, :stranger_invalid_message_response)
  end

  def organization_primary_user_params
    params.permit(:first_name, :last_name, :email, :password)
  end

end