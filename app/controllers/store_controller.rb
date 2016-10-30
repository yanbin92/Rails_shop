class StoreController < ApplicationController
  skip_before_action :authorize
  before_action :set_cart
  def index
  	@products = Product.order(:title)
  	@time = Time.now
  	@count = increment_count
  	#@shown_message = "You've been here #{@count} times" if increment_counter >5
  	@session_greeting_msg = "You've been here #{@count} times" if @count >5 #session_greeting
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

end
