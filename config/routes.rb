DasBoard::Application.routes.draw do
  resources :projects, only: ['index', 'show']
  root 'projects#index'
end
