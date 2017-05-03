Rails.application.routes.draw do
  # sign_up sign_in
  get 		'login' => 'sessions#new'
  post 		'login' => 'sessions#create'
  delete 	'logout' => 'sessions#destroy'

  namespace :admin do
    resources :products
  end
end
