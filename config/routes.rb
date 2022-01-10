Rails.application.routes.draw do
  get 'chats/show'
  get 'searches/search'
  get 'relationships/followings'
  get 'relationships/followers'
  root to: 'homes#top'
  get 'home/about',to:'homes#about'
  devise_for :users
  resources :books do
    resource :favorites, only: [:create, :destroy]
    resources :book_comments, only: [:create, :destroy] # book/:book_id/book_comments
  end

  # resources book_comments, only: [:destory] #/bookcomments/:id

  resources :users, only: [:show, :edit, :update, :index] do
    resource :relationships, only: [:create, :destroy]
    get 'followings' => 'relationships#followings', as: 'followings'
    get 'followers' => 'relationships#followers', as: 'followers'
  end
  # 検索機能のルーティング
  get '/search', to: 'searches#search'
  # chatのshowアクションをchat/:idとルーティング
  get 'chat/:id', to: 'chats#show', as: 'chat'
  resources :chats, only: [:create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
