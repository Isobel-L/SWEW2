Rails.application.routes.draw do
  root "home#index"

  resource  :profile, only: :show
  resource  :alien_translation, only: :show
  resource  :blast_off, only: :show
  get "pages/home"
  get "home/about"
  get "home/index"
  get "up" => "rails/health#show", as: :rails_health_check
end
