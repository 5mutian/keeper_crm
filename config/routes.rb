Rails.application.routes.draw do
  # sign_up 
  post    'sign_up' => "registrations#create" 
  # sign_in
  get 		'login' => 'sessions#new'
  post 		'login' => 'sessions#create'
  delete 	'logout' => 'sessions#destroy'

  namespace :api do
    namespace :wechat do
      post :auth
    end
    resources :valid_codes, only: [:create] do
      collection do
        post :valid
      end
    end
  	resources :registrations, only: [:create]
  	resources :sessions, only: [:create]

    namespace :auth do
      get :cgj
    end
    
    namespace :sync do
      resources :orders, only: [] do
        collection do
          post :update_cgj
        end
      end
      resources :customers, only: [:create]
      resources :accounts, only: [] do
        collection do
          post :gen_account_user
          post :update_cgj
        end
      end
    end

	  resources :users do # 用户管理
      collection do
        post :update_me
      end
    end
	  resources :clues do # 线索管理
      member do
        post :update
      end
    end
  	resources :stores do # 门店管理
      collection do
        post :update_me
        post :add_region
        get :get_regions
      end 
    end
  	resources :orders do # 订单管理
      collection do
        get :get_cgjs
      end
    end
  	resources :customers do # 客户管理 
      member do
        post :update
      end
    end
    resources :strategies do # 策略管理
      member do
        post :update
      end
    end
    resources :accounts do
      collection do
        get :get_saler_directors
        get :companies
        post :add_company
        post :apply_co_companies
        post :update_apply
        post :update_me
      end
    end
    resources :pres, only: [:index]

    resources :wallets, only: [] do
      collection do
        get  :config
        post :recharge
        post :withdraw
      end
    end
	end

  resources :payments, only: [] do
    collection do
      get :callback
    end
  end

end
