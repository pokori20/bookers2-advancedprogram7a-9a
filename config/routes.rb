Rails.application.routes.draw do
  root to: 'homes#top'
  get 'home/about',to:'homes#about'
  devise_for :users
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resource :book_comments, only: [:create, :destroy]
  end
  resources :users, only: [:show, :edit, :update, :index]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
