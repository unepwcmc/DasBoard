DasBoard::Application.routes.draw do
  root 'projects#index'

  resources :projects, only: ['index', 'show']
  resources :objectives, only: ['create']

  if Rails.env.development?
    get "test", to: 'test#test'
  end
end
