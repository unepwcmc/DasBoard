DasBoard::Application.routes.draw do
  root 'projects#index'

  resources :projects, only: ['index', 'show'] do
    member do
      resources :objectives, only: ['new']
    end
  end

  resources :objectives, only: ['create']
  resources :metrics, only: ['index'] do
    member do
      post 'data'
    end
  end

  resources :models, only: ['update']

  if Rails.env.development?
    get "test", to: 'test#test'
  end
end
