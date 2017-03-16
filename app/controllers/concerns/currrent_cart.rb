module CurrentCart
	private 
	# we place the set_cart() method in a CurrentCart module and place thatmodule in the 
	#app/controllers/concernsdirectory.
	#This treatment allows us to share
	#common code (even as little as a single method!) among controllers.
		def  set_cart
			# byebug
			@cart = Cart.find(session[:cart.id])
			rescue ActiveRecord::RecordNotFound 
				@cart= Cart.create
				session[:cart_id]=@cart.id
		end
end

#注意，删除会话中的数据是把键的值设为 nil，但要删除 cookie 中的值，要使用 cookies.delete(:key) 方法