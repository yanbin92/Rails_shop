class SessionsController < ApplicationController
  skip_before_action :authorize
  def new
  end

  def create
  	user = User.find_by(name: params[:name])
    #@person.try(:spouse).try(:name)
    # instead of
    # @person.spouse.name if @person && @person.spouse
    logger.debug "New post: #{user.inspect}"
    #从 2.0 版本开始，Rails 内置了调试功能。在任何 Rails 程序中都可以使用 debugger 方法调出调试器。
    byebug 
  	if user.try(:authenticate, params[:password])
  		session[:user_id] = user.id
  		redirect_to admin_url
  	else
      logger.debug "Invalid user/password #{user.inspect}"
      #日志标签
      logger.tagged("login") { logger.info "Invalid user/password" }
      #如果把日志写入硬盘，肯定会对程序有点小的性能影响。不过可以做些小调整：:debug 等级比 :fatal 等级对性能的影响更大，因为写入的日志消息量更多。
      # 在上述代码中，即使日志等级不包含 :debug 也会对性能产生影响。因为 Ruby 要初始化字符串，再花时间做插值。因此推荐把代码块传给 logger 方法，只有等于或大于设定的日志等级时才会执行其中的代码。重写后的代码如下：

      # logger.debug {"Person attributes hash: #{@person.attributes.inspect}"}
      # 代码块中的内容，即字符串插值，仅当允许 :debug 日志等级时才会执行。这种降低性能的方式只有在日志量比较大时才能体现出来，但却是个好的编程习惯。



  		redirect_to login_url,alert: "Invalid user/password#{user.inspect}"
  	end
  end

  def destroy
  	session[:user_id] = nil
  	redirect_to store_index_url,notice: "Logged out"
  end
end
