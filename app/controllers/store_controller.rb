class StoreController < ApplicationController
  skip_before_action :authorize
  before_action :set_cart
  def index
  	@products = Product.order(:title)
  	@time = Time.now
  	@count = increment_count
  	#@shown_message = "You've been here #{@count} times" if increment_counter >5
  	@session_greeting_msg = "You've been here #{@count} times" if @count >5 #session_greeting
    @title = "My Wonderful Life"
    #Sets the etag and/or last_modified on the response and checks it against the client request. If the request doesn't match the options provided, the request is considered stale and should be generated from scratch. Otherwise, it's fresh and we don't need to generate anything and a reply of 304 Not Modified is sent.
    # 如果根据指定的时间戳和 etag 值判断请求的内容过期了
    # （即需要重新处理）执行这个块
    # if stale?(last_modified: @products[0].updated_at.utc,etag: @products[0].cache_key)
    #   # byebug
    #   respond_to do |format|
    #     ##..正常处理响应
    #    format.html {render}
    #   end
    # end
    # 如果请求的内容还新鲜（即未修改），无需做任何事
    # render 默认使用前面 stale? 中的参数做检查，会自动发送 :not_modified 响应
    # 就这样，工作结束
    # 除了散列，还可以传入模型。Rails 会使用 updated_at 和 cache_key 方法设定 last_modified 和 etag：

    #   def show
    #     @product = Product.find(params[:id])

    #     if stale?(@product)
    #       respond_to do |wants|
    #         # ... 正常处理响应
    #       end
    #     end
    #   end
  end

 def increment_count
	#session[:counter] ||= 0
	#session[:counter] += 1
	if(session[:counter].nil?)
  	session[:counter] = 0
  else
  	session[:counter] +=1
  end
 end

 def session_greeting
  if @count == 0
    session_greeting = "welcome!" 
  else
    session_greeting = @count
  end
 end

  


 def rss
    render(layout: false) # never use a layout
 end

 def checkout
  render(layout: "layouts/simple")
 end
#layout demo
 # layout "standard", except: [:rss,:atom]# view/layout/standard.html.erb  overload layout  all action's view
  #layout :determine_layout
  # ...
  private
  def determine_layout
    if Store.is_closed?
     "store_down"
    else
      "standard"  # Rails supports this need with dynamic layouts
    end
  end
 


end
