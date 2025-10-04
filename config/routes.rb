Rails.application.routes.draw do
  root "home#index"

  resource  :profile, only: :show
  resource  :blast_off, only: :show
  get "pages/home"
  get "home/about"
  get "home/index"
  get "up" => "rails/health#show", as: :rails_health_check
  get  "alien_translation", to: "alien_translations#alien_translation", as: :alien_translation
  post "alien_translation", to: "alien_translations#create"
  post "alien_translation/hint", to: "alien_translations#hint", as: :alien_translation_hint
  post "alien_translation/change_difficulty",
     to: "alien_translations#change_difficulty",
     as: :change_difficulty_alien_translation

end
