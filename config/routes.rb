Rails.application.routes.draw do
  root "pages#home"
# Routes
get "profile", to: "pages#profile", as: :profile
get "account", to: "pages#account", as: :account
patch "account", to: "pages#update_account"

get "login", to: "sessions#new"
post "login", to: "sessions#create"
delete "logout", to: "sessions#destroy"

 get "up" => "rails/health#show", as: :rails_health_check
end
