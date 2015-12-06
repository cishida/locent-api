Rails.application.routes.draw do

  namespace :api, defaults: {format: :json} do

  end

  namespace :dashboard, defaults: {format: :json}  do
    scope module: :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :users, only: [:show]
      resources :organisations, only: [:show, :create, :index, :update, :destroy]
      resources :sessions, only: [:create, :destroy]
    end
  end

end
