  Rails.application.routes.draw do
    root "books#index"

    resources :books do
      resources :reviews, only: [:index, :create, :update, :destroy], shallow: true
    end

    resources :reviews, only: [ :index, :create, :update, :destroy ]

    get "up" => "rails/health#show", as: :rails_health_check
  end
