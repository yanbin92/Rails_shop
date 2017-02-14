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
####!!!嵌套资源不可超过一层。


  # concern :reviewable do
  #   resources :reviews
  # end
  # resources :products, concern: :reviewable

  #shallow route nesting 
  # resources :products, shallow: true do
  #   resources :reviews
  # end

#避免深层嵌套的方法之一，是把控制器集合动作放在父级资源中，表明层级关系，但不嵌套成员动作。也就是说，用最少的信息表明资源的路由关系，如下所示：

  # resources :articles do
  #   resources :comments, only: [:index, :new, :create]
  # end
  # resources :comments, only: [:show, :edit, :update, :destroy]

  #scope 方法有两个选项可以定制浅层嵌套路由。:shallow_path 选项在成员路径前加上指定的前缀：
  #routing 
  # scope shallow_path: "sekret" do
  #   resources :articles do
  #     resources :comments, shallow: true
  #   end
  # end
  # 上述代码为 comments 资源生成的路由如下：

  # HTTP 方法 路径  控制器#动作  具名帮助方法
  # GET /articles/:article_id/comments(.:format)  comments#index  article_comments_path
  # POST  /articles/:article_id/comments(.:format)  comments#create article_comments_path
  # GET /articles/:article_id/comments/new(.:format)  comments#new  new_article_comment_path
  # GET /sekret/comments/:id/edit(.:format) comments#edit edit_comment_path
  # GET /sekret/comments/:id(.:format)  comments#show comment_path
  # PATCH/PUT /sekret/comments/:id(.:format)  comments#update comment_path
  # DELETE  /sekret/comments/:id(.:format)  comments#destroy  comment_path


  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #get '/clients/:status' => 'clients#index', foo: 'bar'

  #在这个例子中，用户访问 /clients/active 时，params[:status] 的值是 "active"。同时，params[:foo] 的值也会被设为 "bar"，就像通过请求参数传入的一样。params[:action] 也是一样，其值为 "index"
  ###WEBrick 会缓冲所有响应，因此引入 ActionController::Live 也不会有任何效果。你应该使用不自动缓冲响应的服务器。

end
