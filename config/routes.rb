Rails.application.routes.draw do
  root 'static_pages#home'
  devise_for :users,  :controllers => {
    :registrations => 'users/registrations'
   }
  #, controllers: { registrations: 'users/registrations' }

  get 'static_pages/home'
  get 'static_pages/help'
  get 'static_pages/about'
  get 'static_pages/contact'

  get  '/help',    to: 'static_pages#help'
  get  '/about',   to: 'static_pages#about'
  get  '/contact', to: 'static_pages#contact'

  resources :users do
    member do
      get :following, :followers, :likes
    end
  end
  
  resources :microposts, only: [:create, :show, :destroy] do
    resources :comments, only:[:create, :destroy]
  end

  resources :relationships, only: [:create, :destroy]
  
  resources :favorite_relationships, only: [:create, :destroy]

  resources :messages, :only => [:create]
  resources :rooms, :only => [:create, :show, :index]
end
