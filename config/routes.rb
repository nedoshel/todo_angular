TodoAngular::Application.routes.draw do
  resources :tasks, only: [:index, :create, :update, :destroy]

  root to: 'tasks#index'
end
