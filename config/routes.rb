Rails.application.routes.draw do
  root "home#index"

  resource  :profile, only: :show
  resource  :blast_off, only: :show
  get "pages/home"
  get "home/about"
  get "home/index"
  get "up" => "rails/health#show", as: :rails_health_check
  get "alien_translation", to: "games#alien_translation", as: :alien_translation
  post "alien_translation", to: "games#create"
  post "alien_translation/hint", to: "games#hint", as: :alien_translation_hint
end
