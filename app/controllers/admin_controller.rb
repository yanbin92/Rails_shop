class AdminController < ApplicationController
  def index
  	@total_orders = Order.count
  end

  #HTTP 摘要身份认证
  #  USERS = { "lifo" => "world" }
 
  # before_action :authenticate
 
  # private
 
  #   def authenticate
  #     authenticate_or_request_with_http_digest do |username|
  #       USERS[username]
  #     end
  #   end
end
