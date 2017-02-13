class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authorize 

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
