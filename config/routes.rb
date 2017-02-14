require './app/store'
Rails.application.routes.draw do
  match 'catalog' => StoreApp.new,via: :all
  get 'upload/picture'
  get 'upload',to: 'upload#get'#as 'upload' #as 'upload'== upload_path() 
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

  resources :users #使用资源路径可以快速声明资源式控制器所有的常规路由，无需分别为 index、show、new、edit、create、update 和 destroy 动作分别声明路由，只需一行代码就能搞定。
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

  #控制器命名空间和路由
  # namespace :admin do
  #   resources :articles, :comments
  # end
  #嵌套资源
#   class Magazine < ActiveRecord::Base
#   has_many :ads
# end
 
# class Ad < ActiveRecord::Base
#   belongs_to :magazine
# end
# 在路由中可以使用“嵌套路由”反应这种关系。针对这个例子，可以声明如下路由：

# resources :magazines do
#   resources :ads
# end
# 除了创建 MagazinesController 的路由之外，上述声明还会创建 AdsController 的路由。广告的 URL 要用到杂志资源：

# HTTP 方法 路径  控制器#动作  作用
# GET /magazines/:magazine_id/ads ads#index 显示指定杂志的所有广告
# GET /magazines/:magazine_id/ads/new ads#new 显示新建广告的表单，该告属于指定的杂志
# POST  /magazines/:magazine_id/ads ads#create  创建属于指定杂志的广告
# GET /magazines/:magazine_id/ads/:id ads#show  显示属于指定杂志的指定广告
# GET /magazines/:magazine_id/ads/:id/edit  ads#edit  显示编辑广告的表单，该广告属于指定的杂志
# PATCH/PUT /magazines/:magazine_id/ads/:id ads#update  更新属于指定杂志的指定广告
# DELETE  /magazines/:magazine_id/ads/:id ads#destroy 删除属于指定杂志的指定广告



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
