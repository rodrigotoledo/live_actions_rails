Rails.application.routes.draw do
  resource :example, constraints: -> { Rails.env.development? }
  resources :tasks
  root 'tasks#index'
end
