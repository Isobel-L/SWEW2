Rails.application.routes.draw do
  root "pages#home"
 # Routes
  get "profile", to: "pages#profile", as: :profile
  get "account", to: "pages#account", as: :account
  patch "account", to: "pages#update_account"
  get "login", to: "pages#login", as: :login #Just /login to access for now
  get "up" => "rails/health#show", as: :rails_health_check
end
