class ApplicationController < ActionController::API
  include ActionController::ImplicitRender, ActionController::HttpAuthentication::Token::ControllerMethods
  respond_to :json


end
