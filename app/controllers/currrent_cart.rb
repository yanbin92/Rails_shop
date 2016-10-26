module CurrentCart
	private 
	# we place the set_cart() method in a CurrentCart module and place thatmodule in the 
	#app/controllers/currrent_cart.rb.
	#This treatment allows us to share
	#common code (even as little as a single method!) among controllers.
		def  set_cart
			@cart = Cart.find(session[:cart.id])
			rescue ActiveRecord::RecordNotFound 
				@cart= Cart.create
				session[:cart_id]=@cart.id
		end
end

