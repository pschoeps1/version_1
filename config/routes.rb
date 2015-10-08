require 'api_constraints'

Version1::Application.routes.draw do
  devise_for :users
  # Api definition
  namespace :api, defaults: { format: :json },
                                constraints: { subdomain: 'api' }, path: '/' do
    # modules for versioning
    scope module: :v1,
              constraints: ApiConstraints.new(version: 1, default: true) do
      resources :users, :only => [:show]
    end
  end
end
