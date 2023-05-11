Rails.application.routes.draw do
  root 'homes#top'
  get "home/about"=>"homes#about"
  
  devise_for :users

  resources :users, except: [:new, :create, :destroy] do
    resource :relationships, only: [:create, :destroy]
  	get 'followings' => 'relationships#followings', as: 'followings'
  	get 'followers' => 'relationships#followers', as: 'followers'
  end
  
  resources :books, except: [:new] do
    resources :book_comments, only: [:create, :destroy]
    resource :favorites, only: [:create, :destroy]
  end
end
