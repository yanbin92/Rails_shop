require './app/store'
Rails.application.routes.draw do
  match 'catalog' => StoreApp.new,via: :all
  #非资源式路由
  get 'upload/picture'
#    定义默认值
# 在路由中无需特别使用 :controller 和 :action，可以指定默认值：

# get 'photos/:id', to: 'photos#show'
  get 'upload',to: 'upload#get'#as 'upload' #as 'upload'== upload_path() 
 
  # 绑定参数
  # 声明常规路由时，可以提供一系列 Symbol，做为 HTTP 请求的一部分，传入 Rails 程序。其中两个 Symbol 有特殊作用：:controller 映射程序的控制器名，:action 映射控制器中的动作名。例如，有下面的路由：
  # get ':controller(/:action(/:id))'

# 动态路径片段
# 在常规路由中可以使用任意数量的动态片段。:controller 和 :action 之外的参数都会存入 params 传给动作。如果有下面的路由：

# get ':controller/:action/:id/:user_id'
# /photos/show/1/2 请求会映射到 PhotosController 的 show 动作。params[:id] 的值是 "1"，params[:user_id] 的值是 "2"。

#声明路由时可以指定静态路径片段，片段前不加冒号即可：

# get ':controller/:action/:id/with_user/:user_id'
# 这个路由能响应 /photos/show/1/with_user/2 这种路径。此时，params 的值为 { controller: 'photos', action: 'show', id: '1', user_id: '2' }。

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
  #routing :shallow_path 选项在成员路径前加上指定的前缀：
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
#:shallow_prefix 选项在具名帮助方法前加上指定的前缀：

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  #get '/clients/:status' => 'clients#index', foo: 'bar'

  #在这个例子中，用户访问 /clients/active 时，params[:status] 的值是 "active"。同时，params[:foo] 的值也会被设为 "bar"，就像通过请求参数传入的一样。params[:action] 也是一样，其值为 "index"
  ###WEBrick 会缓冲所有响应，因此引入 ActionController::Live 也不会有任何效果。你应该使用不自动缓冲响应的服务器。


##2.8Routing Concerns 用来声明通用路由，可在其他资源和路由中重复使用。定义 concern 的方式如下：

  # concern :commentable do
  #   resources :comments
  # end
   
  # concern :image_attachable do
  #   resources :images, only: :index
  # end
  # Concerns 可在资源中重复使用，避免代码重复：

  # resources :messages, concerns: :commentable
   
  # resources :articles, concerns: [:commentable, :image_attachable]
  # 上述声明等价于：

  # resources :messages do
  #   resources :comments
  # end
   
  # resources :articles do
  #   resources :comments
  #   resources :images, only: :index
  # end
  # Concerns 在路由的任何地方都能使用，例如，在作用域或命名空间中：

  # namespace :articles do
  #   concerns :commentable
  # end

# <%= link_to 'Edit Ad', [:edit, @magazine, @ad] %>
###添加额外的集合路由或成员路由
# resources :photos do
#   member do
#     get 'preview'
#   end
# end
# 这段路由能识别 /photos/1/preview 是个 GET 请求，映射到 PhotosController 的 preview 动作上，资源的 ID 传入 params[:id]。同时还生成了 preview_photo_url 和 preview_photo_path 两个帮助方法。
###添加集合路由  添加集合路由的方式如下：
  # resources :photos do   
  #   collection do     
  #     get 'search'  
  #    end
  #   end 
  #   这段路由能识别 /photos/search 是个 GET 请求，映射到 PhotosController 的 search 动作上。同时还会生成 search_photos_url 和 search_photos_path 两个帮助方法。

  #集合和成员的区别 是生成的路径不同 mem有资源id


# 添加额外新建动作的路由

# 要添加额外的新建动作，可以使用 :on 选项：

# resources :comments do
#   get 'preview', on: :new
# end
# 这段代码能识别 /comments/new/preview 是个 GET 请求，映射到 CommentsController 的 preview 动作上。同时还会生成 preview_new_comment_url 和 preview_new_comment_path 两个路由帮助方法。

#####如果在资源式路由中添加了过多额外动作，这时就要停下来问自己，是不是要新建一个资源。

end
