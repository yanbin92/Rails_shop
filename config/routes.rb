require './app/store'
Rails.application.routes.draw do
  resources :articles
  #使用 :as 选项可以为路由起个名字：
  #root 路由应该放在文件的顶部，因为这是最常用的路由，应该先匹配。
  root 'store#index',as: 'store_index'
  #root 路由只处理映射到动作上的 GET 请求。


  match 'catalog' => StoreApp.new,via: :all
  #非资源式路由
  get 'upload/picture'
####定义默认值
# 在路由中无需特别使用 :controller 和 :action，可以指定默认值：

# get 'photos/:id', to: 'photos#show'
# get 'photos/:id', to: 'photos#show', defaults: { format: 'jpg' }
# Rails 会把 photos/12 请求映射到 PhotosController 的 show 动作上，把 params[:format] 的值设为 "jpg"。
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

  #这段路由会生成 store_index_path 和 store_index_url 这两个具名路由帮助方法。调用 logout_path 方法会返回 /exit。
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

#   :except 选项指定不用生成的路由：

# resources :photos, except: :destroy  #此时，Rails 会生成除 destroy（向 /photos/:id 发起的 DELETE 请求）之外的所有常规路由。

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


## HTTP 方法约束
# 使用 match 方法，可以通过 :via 选项一次指定多个 HTTP 方法：

# match 'photos', to: 'photos#show', via: [:get, :post]
# 如果某个路由想使用所有 HTTP 方法，可以使用 via: :all：

# match 'photos', to: 'photos#show', via: :all
# 同个路由即处理 GET 请求又处理 POST 请求有安全隐患。一般情况下，除非有特殊原因，切记不要允许在一个动作上使用所有 HTTP 方法。

####路径片段约束
# 可使用 :constraints 选项限制动态路径片段的格式：

# get 'photos/:id', to: 'photos#show', constraints: { id: /[A-Z]\d{5}/ }
# 这个路由能匹配 /photos/A12345，但不能匹配 /photos/893。上述路由还可简化成：

# get 'photos/:id', to: 'photos#show', id: /[A-Z]\d{5}/
# :constraints 选项中的正则表达式不能使用“锚记”。例如，下面的路由是错误的：

# get '/:id', to: 'photos#show', constraints: {id: /^\d/}
# 之所以不能使用锚记，是因为所有正则表达式都从头开始匹配。

# 例如，有下面的路由。如果 to_param 方法得到的值以数字开头，例如 1-hello-world，就会把请求交给 articles 控制器处理；如果 to_param 方法得到的值不以数字开头，例如 david，就交给 users 控制器处理。

# get '/:id', to: 'articles#show', constraints: { id: /\d.+/ }
# get '/:username', to: 'users#show'
  
#约束还可以根据任何一个返回值为字符串的 Request 方法设定。

# 基于请求的约束和路径片段约束的设定方式一样：

# get 'photos', constraints: {subdomain: 'admin'} 

###高级约束 
# 如果约束很复杂，可以指定一个能响应 matches? 方法的对象。假设要用 BlacklistConstraint 过滤所有用户，可以这么做：

# class BlacklistConstraint
#   def initialize
#     @ips = Blacklist.retrieve_ips
#   end
 
#   def matches?(request)
#     @ips.include?(request.remote_ip)
#   end
# end
 
# TwitterClone::Application.routes.draw do
#   get '*path', to: 'blacklist#index',
#     constraints: BlacklistConstraint.new
# end

#   get '*path', to: 'blacklist#index',
#    constraints: lambda { |request| Blacklist.retrieve_ips.include?(request.remote_ip) }

# 通配片段 难理解 语法
# 路由中的通配符可以匹配其后的所有路径片段。例如：

# get 'photos/*other', to: 'photos#unknown'

#重定向
# 在路由中可以使用 redirect 帮助方法把一个路径重定向到另一个路径：

# get '/stories', to: redirect('/articles')


# :controller 选项用来指定资源使用的控制器。例如：
# resources :photos, controller: 'images'

  #指定约束
  # constraints(id: /[A-Z][A-Z][0-9]+/) do
  #   resources :photos
  #   resources :accounts
  # end

# :path_names 选项可以改写路径中自动生成的 "new" 和 "edit" 片段：

# resources :photos, path_names: { new: 'make', edit: 'change' }
# 这样设置后，路由就能识别如下的路径：

# /photos/make
# /photos/1/change
# 这个选项并不能改变实际处理请求的动作名。上述两个路径还是交给 new 和 edit 动作处理。

# 使用 scope 时，可以改写资源生成的路径名：

# scope(path_names: { new: 'neu', edit: 'bearbeiten' }) do
#   resources :categories, path: 'kategorien'
# end

# http://localhost:3000/rails/info/routes
# CONTROLLER=users rake routes
# ce试路由
# 和程序的其他部分一样，路由也要测试。Rails 内建了三个断言，可以简化测试：
# assert_generates
# assert_recognizes
# assert_routing
# assert_routing 做双向测试：检测路径是否能生成选项，以及选项能否生成路径。因此，综合了 assert_generates 和 assert_recognizes 两个断言。

end
