Rails.application.routes.draw do
  root "pages#home"

  resource  :blast_off, only: :show
  get "pages/home"
  get "home/about"
  get "home/index"

  get  "alien_translation", to: "alien_translations#alien_translation", as: :alien_translation
  post "alien_translation", to: "alien_translations#create"
  post "alien_translation/hint", to: "alien_translations#hint", as: :alien_translation_hint
  post "alien_translation/change_difficulty",
       to: "alien_translations#change_difficulty",
       as: :change_difficulty_alien_translation

  get   "account", to: "pages#account",       as: :account
  patch "account", to: "pages#update_account"
  get "profile", to: "pages#home", as: :profile

  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get  "signup", to: "users#new"
  post "signup", to: "users#create"

  get "blast_off", to: "blast_off#show"
  post "blast_off/check", to: "blast_off#check"


  get "up" => "rails/health#show", as: :rails_health_check
  
end
