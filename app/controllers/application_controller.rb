class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :authorize


  	
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
