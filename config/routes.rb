Rails.application.routes.draw do
  # sign_up 
  post    'sign_up' => "registration#create" 
  # sign_in
  get 		'login' => 'sessions#new'
  post 		'login' => 'sessions#create'
  delete 	'logout' => 'sessions#destroy'

  namespace :admin do
    resources :users
  end
end
