class Dashboard::V1::OrganizationsController < ActionController::API
  include ActionController::ImplicitRender
  respond_to :json

  def index
    respond_with Organization.all
  end

  def show
    respond_with Organization.find(params[:id])
  end

  def create
    @organization = Organization.new(organization_params)
    if create_primary_user_account && @organization.save
      render json: @organization, status: 201, location: [:dashboard, @organization]
    else
      render json: {errors: combined_errors, status: 422}
      @user.really_destroy!
    end
  end

  def update
    @organization = Organization.find(params[:id])
    @organization.update(organization_params)
    if @organization.update(organization_params)
      render json: @organization, status: 201, location: [:dashboard, @organization]
    else
      render json: {errors: @organization.errors.full_messages}, status: 422
    end
  end

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

  private

  def organization_params
    params.permit(:organization_name, :email, :phone)
  end

  def organization_primary_user_params
    params.permit(:first_name, :last_name, :email, :password)
  end

end