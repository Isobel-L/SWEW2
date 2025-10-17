Rails.application.routes.draw do
  # Keep your current root (change if you prefer the Pages controller)
  root "home#home"

  # --- Your existing routes ---
  resource  :profile,   only: :show
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

  # --- Friend's additions (no helper/name clashes) ---
  get   "account", to: "pages#account",       as: :account
  patch "account", to: "pages#update_account"

  get    "login",  to: "sessions#new"
  post   "login",  to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Single health check route
  get "up" => "rails/health#show", as: :rails_health_check
end
