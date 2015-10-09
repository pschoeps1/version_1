#require 'api_constraints'

Version1::Application.routes.draw do
  devise_for :users
  # Api definition
  api_version(:module => "api/v1", :path => {:value => "v1"}, defaults: { format: :json }) do
      resources :users, :only => [:show]
  end
end
