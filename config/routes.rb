DasBoard::Application.routes.draw do
  resources :projects, only: ['index', 'show']
  root 'projects#index'

  if Rails.env.development?
    get "test", to: 'test#test'
  end
end
