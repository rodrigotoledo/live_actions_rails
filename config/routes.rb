# frozen_string_literal: true

Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
  resource :example, constraints: -> { Rails.env.development? }
  resources :tasks do
    collection do
      post :search
    end
  end
  root "tasks#index"
end
