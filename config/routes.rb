Rails.application.routes.draw do
  resources :pay_types
  resources :orders
  resources :line_items do
  	#member do 
  	#	put 'decrement'
  	#end
  	put 'decrement', on: :member
  end
  resources :carts
  root 'store#index',as: 'store_index'

  resources :products do
    get :who_bought, on: :member
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
