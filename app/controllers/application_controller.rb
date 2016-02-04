class ApplicationController < ActionController::API
  include DeviseTokenAuth::Concerns::SetUserByToken
  include ActionController::ImplicitRender, ActionController::HttpAuthentication::Token::ControllerMethods
  respond_to :json


end
