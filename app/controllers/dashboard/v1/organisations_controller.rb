class Dashboard::V1::OrganisationsController < ActionController::API
  include ActionController::ImplicitRender
  respond_to :json

  def index
    respond_with Organisation.all
  end

  def show
    respond_with Organisation.find(params[:id])
  end

  def create
    @organisation = Organisation.new(organisation_params)


    if create_primary_user_account && @organisation.save
      render json: @organisation, status: 201, location: [:dashboard, @organisation]
    else
      render json: {errors: combined_errors, status: 422}
      @user.really_destroy!
    end
  end

  def update
    @organisation = Organisation.find(params[:id])
    @organisation.update(organisation_params)

    if @organisation.update(organisation_params)
      render json: @organisation, status: 201, location: [:dashboard, @organisation]
    else
      render json: {errors: @organisation.errors.full_messages}, status: 422
    end
  end

  def create_primary_user_account
    @user = @organisation.build_primary_user(organisation_primary_user_params)
    @user.save
  end

  def combined_errors
    @user.errors.full_messages.each do |message|
      @organisation.errors[:user] << (message)
    end
    return @organisation.errors.full_messages
  end

  private

  def organisation_params
    params.permit(:organisation_name, :email, :phone)
  end

  def organisation_primary_user_params
    params.permit(:first_name, :last_name, :email, :password)
  end

end