class Dashboard::V1::ProductsController < ApplicationController
  include ActionController::ImplicitRender
  respond_to :json

  def index
    respond_with Product.all
  end

end