# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  post 'login', to: 'authentication#login', as: 'login'

  namespace :api do
    namespace :v1 do
      resources :tasks
    end
  end
end
