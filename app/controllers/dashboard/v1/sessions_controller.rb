class Dashboard::V1::SessionsController < ActionController::API
  include ActionController::ImplicitRender


  def create
    @user_password = params[:password]
    @user_email = params[:email]
    @user = user_email.present? && User.find_by_email(user_email)

    if user.valid_password? @user_password
      sign_in @user, store: false
      @user.generate_authentication_token!
      @user.save
      render json: @user, status: 200, location: [:dashboard, @user]
    else
      render json: {errors: 'Invalid email or password'}
    end
  end


  def destroy
    @user = User.find_by_auth_token(params[:id])
    @user.generate_authentication_token!
    @user.save
    head 204
  end
end
