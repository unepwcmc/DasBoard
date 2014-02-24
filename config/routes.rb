DasBoard::Application.routes.draw do
  root 'projects#index'

  resources :projects, only: [:index, :show, :update] do
    member do
      resources :objectives, only: ['new']
    end
  end

  resources :objectives, only: [:create, :update, :destroy]
  resources :metrics, only: [:index, :new, :show] do
    member do
      post 'data'
    end
  end

  if Rails.env.development?
    get "test", to: 'test#test'
  end
end
