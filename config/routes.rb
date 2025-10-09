Rails.application.routes.draw do
  root "pages#home"

  get "profile", to: "pages#profile", as: :profile
  get "account", to: "pages#account", as: :account
  patch "account", to: "pages#update_account"

  get "up" => "rails/health#show", as: :rails_health_check
end
