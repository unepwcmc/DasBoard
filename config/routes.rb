DasBoard::Application.routes.draw do
  root 'projects#index'

  resources :projects, only: ['index', 'show']
  resources :objectives, only: ['create']
  resources :metrics, only: ['index'] do
    member do
      post 'data'
    end
  end

  if Rails.env.development?
    get "test", to: 'test#test'
  end
end
