module Authenticable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate
  end

  protected
  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      @organization = Organization.find_by(auth_token: token)
    end
  end

  def render_unauthorized
    head status: :unauthorized
  end

end