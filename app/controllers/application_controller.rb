class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken, ActionController::ImplicitRender
  before_action :configure_permitted_parameters, if: :devise_controller?


  rescue_from RailsParam::Param::InvalidParameterError do |exception|
    render json: {errors: exception}, status: 422
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name]
  end

end
