Rails.application.routes.draw do
  devise_for :users

  post 'login', to: 'authentication#login', as: 'login'
end
