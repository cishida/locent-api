Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: {format: :json} do

  end

  namespace :dashboard, defaults: {format: :json}  do
    scope module: :v1 do
      resources :users, only: [:show, :destroy, :create, :update]
      resources :organisations, only: [:show, :create, :index, :update, :destroy]
      resources :sessions, only: [:create, :destroy]
    end
  end

end
