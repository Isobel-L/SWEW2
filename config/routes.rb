Rails.application.routes.draw do
  root "pages#home"

  get "profile", to: "pages#profile", as: :profile
  get "account", to: "pages#account", as: :account
  patch "account", to: "pages#update_account"

  get "blast_off", to: "blast_off#show"
  post "blast_off/check", to: "blast_off#check"


  get "up" => "rails/health#show", as: :rails_health_check
end
