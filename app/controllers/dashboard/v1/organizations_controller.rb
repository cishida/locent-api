class Dashboard::V1::OrganizationsController < DashboardController
  before_action :authenticate_user!, only: :update
  before_action :validate_create_params, only: :create
  before_action :validate_update_params, only: :update

  def index
    respond_with Organization.all
  end

  def show
    respond_with Organization.find(params[:id])
  end

  def create
    @organization = Organization.new(organization_params)
    provision_number_for_organization
    if @organization.save && create_primary_user_account
      render json: @organization, status: 201, location: [:dashboard, @organization]
    else
      render json: {errors: combined_errors}, status: 422
      @user.really_destroy!
    end
  end

  def update
    @organization = current_user.organization
    @organization.update(organization_params)
    if @organization.update(organization_params)
      render json: @organization, status: 201, location: [:dashboard, @organization]
    else
      render json: {errors: @organization.errors.full_messages}, status: 422
    end
  end


  private

  def create_primary_user_account
    @user = @organization.build_primary_user(organization_primary_user_params)
    @user.save
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

  def organization_params
    params.permit(:organization_name, :email, :phone)
  end

  def organization_primary_user_params
    params.permit(:first_name, :last_name, :email, :password)
  end

  def provision_number_for_organization
    @client = Twilio::REST::Client.new Rails.application.secrets.twilio_account_sid, Rails.application.secrets.twilio_auth_token
    numbers = @client.available_phone_numbers.get('US').list()
    @number = numbers[0].purchase()
    @number.update(
        sms_url: "http://locent-api.herokuapp.com/receive",
        sms_method: "POST"
    )
    @organization.long_number = @number.to_s
  end

end