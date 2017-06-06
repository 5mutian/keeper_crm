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

    namespace :auth do
      get :cgj
    end
    
    namespace :sync do
      resources :orders, only: [] do
        collection do
          patch :update_cgj
        end
      end
      resources :customers, only: [:create]
      resources :accounts, only: [] do
        collection do
          get :get_saler_directors
          post :gen_account_user
        end
      end
    end

	  resources :users # 用户管理
	  resources :clues # 线索管理
  	resources :stores do # 门店管理
      collection do
        get :get_regions
      end 
    end
  	resources :orders do # 订单管理
      collection do
        get :get_cgjs
      end
    end
  	resources :customers # 客户管理
    resources :strategies # 策略管理
    resources :dealers, only: [] do
      collection do
        post :apply_co_companies
      end
    end
    resources :accounts do
      member do
        get :companies
        post :add_company
      end
    end
	end

end
