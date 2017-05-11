Rails.application.routes.draw do
  # sign_up 
  post    'sign_up' => "registrations#create" 
  # sign_in
  get 		'login' => 'sessions#new'
  post 		'login' => 'sessions#create'
  delete 	'logout' => 'sessions#destroy'

  namespace :api do
  	resources :registrations, only: [:create]
  	resources :sessions, only: [:create]

	  resources :users # 用户管理
	  resources :clues # 线索管理
  	resources :stores do # 门店管理
      patch :update_products
    end
  	resources :orders # 订单管理
  	resources :customers # 客户管理

	end

end
