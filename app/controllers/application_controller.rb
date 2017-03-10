class ApplicationController < ActionController::Base
  #为了防止其他各种伪造请求，我们引入了安全令牌，这个安全令牌只有我们自己的网站知道，其他网站不知道。我们把安全令牌包含在请求中，并在服务器上进行验证。安全令牌在应用的控制器中使用下面这行代码设置，这也是新建 Rails 应用的默认值：
  # protect_from_forgery with: :exception
  # 这行代码会在 Rails 生成的所有表单和 Ajax 请求中包含安全令牌。如果安全令牌验证失败，就会抛出异常。
  protect_from_forgery with: :exception
  #默认情况下，Rails 会包含 jQuery 和 jQuery 非侵入式适配器，后者会在 jQuery 的每个非 GET Ajax 调用中添加名为 X-CSRF-Token 的首部，其值为安全令牌。如果没有这个首部，Rails 不会接受非 GET Ajax 请求。使用其他库调用 Ajax 时，同样要在默认首部中添加 X-CSRF-Token。要想获取令牌，请查看应用视图中由 <%= csrf_meta_tags %> 这行代码生成的 <meta name='csrf-token' content='THE-TOKEN'> 标签。
  before_action :authorize 
# rescue_from 截获所有 ActiveRecord::RecordNotFound 异常，然后做相应的处理。

# class ApplicationController < ActionController::Base
#   rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
 
#   private
 
#     def record_not_found
#       render plain: "404 Not Found", status: 404
#     end
# end
#这段代码对异常的处理并不详尽，比默认的处理也没好多少。不过只要你能捕获异常，就可以做任何想做的处理。例如，可以新建一个异常类，用户无权查看页面时抛出：

  #过滤器 除了前置过滤器之外，还可以在动作运行之后，或者在动作运行前后执行过滤器around_action :wrap_in_transaction, only: :show
  #在每个控制器中都有两个存取器方法，分别用来获取当前请求循环的请求对象和响应对象。request 方法的返回值是 AbstractRequest 对象的实例；response 方法的返回值是一个响应对象，表示回送客户端的数据。

  	
  	private 
	# we place the set_cart() method in a CurrentCart module and place thatmodule in the 
	#app/controllers/concernsdirectory.
	#This treatment allows us to share
	#common code (even as little as a single method!) among controllers.
		def  set_cart
			@cart = Cart.find(session[:cart_id])
			rescue ActiveRecord::RecordNotFound 
				@cart= Cart.create
				session[:cart_id]=@cart.id
				
		end

		
	protected
		def authorize
			#可以使用实例方法 session 获取会话
			unless User.find_by(id: session[:user_id])
				redirect_to login_url,notice: "Please log in"
			end
		end
		
end
