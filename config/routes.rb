Rails.application.routes.draw do
  root 'static_pages#home'
  devise_for :users
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
      get :following, :followers
    end
  end
  
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]
 
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
