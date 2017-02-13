require './app/store'
Rails.application.routes.draw do
  match 'catalog' => StoreApp.new,via: :all
  get 'upload/picture'
  get 'upload/get'
  get 'upload/:id',to: 'upload#show'#那么这个请求就交给 upload 控制器的 show 动作处理，并把 { id: '17' } 传入 params。


  get 'upload/download_img'
  post 'upload/save'#create
  get 'admin' => 'admin#index'

  controller :users do
   get 'users/page1' => :page1
  end
  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy
  end
  # get 'sessions/new'

  # get 'sessions/create'

  # get 'sessions/destroy'

  resources :users
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

  # concern :reviewable do
  #   resources :reviews
  # end
  # resources :products, concern: :reviewable

  #shallow route nesting 
  # resources :products, shallow: true do
  #   resources :reviews
  # end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #get '/clients/:status' => 'clients#index', foo: 'bar'

  #在这个例子中，用户访问 /clients/active 时，params[:status] 的值是 "active"。同时，params[:foo] 的值也会被设为 "bar"，就像通过请求参数传入的一样。params[:action] 也是一样，其值为 "index"
  ###WEBrick 会缓冲所有响应，因此引入 ActionController::Live 也不会有任何效果。你应该使用不自动缓冲响应的服务器。

end
