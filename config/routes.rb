ShareProject::Application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create, :destroy]
  resources :projects, only: [:new, :create, :edit, :update, :destroy, :show, :switch, :share, :unshare, :share_to]

  get "users/new"
  root to: 'static_pages#home'
  match '/help',    to: 'static_pages#help',    via: 'get'
  match '/about',   to: 'static_pages#about',   via: 'get'
  match '/contact', to: 'static_pages#contact', via: 'get'

  match '/newproject',  to: 'projects#new',     via: 'get'
  match '/project_show',  to: 'projects#show',  via: 'get'
  match '/project_switch', to: 'projects#switch',  via: 'get'
  match '/share',   to: 'projects#share',       via: 'get'
  match '/unshare', to: 'projects#unshare',     via: 'get'
  match '/share_to',to: 'projects#share_to',    via: 'post'
  match '/signup',  to: 'users#new',            via: 'get'
  match '/signin',  to: 'sessions#new',         via: 'get'
  match '/signout', to: 'sessions#destroy',     via: 'delete'
end
