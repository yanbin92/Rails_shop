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
  layout "standard", except: [:rss,:atom]# view/layout/standard.html.erb  overload layout  all action's view
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
