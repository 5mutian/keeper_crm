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
	  namespace :admin do
	    resources :users
	  end
	  namespace :saler do
	  	resources :clues
	  end
	  namespace :acct do
	  end
	end

end
