class SessionsController < ApplicationController
  # 会话安全指南
  # 下面是一些关于会话安全的一般性指南。
  # 不要在会话中储存大型对象，而应该把它们储存在数据库中，并将其 ID 保存在会话中。这么做可以避免同步问题，并且不会导致会话存储空间耗尽（会话存储空间的大小取决于其类型，详见后文）。如果不这么做，当修改了对象结构时，用户 cookie 中保存的仍然是对象的旧版本。通过在服务器端储存会话，我们可以轻而易举地清除会话，而在客户端储存会话，要想清除会话就很麻烦了。
  # 关键数据不应该储存在会话中。如果用户清除了 cookie 或关闭了浏览器，这些关键数据就会丢失。而且，在客户端储存会话，用户还能读取关键数据。
  skip_before_action :authorize
  before_action :set_cart ,except: [:destroy]
  def new
  end

  def create
  	user = User.find_by(name: params[:name])
    #@person.try(:spouse).try(:name)
    # instead of
    # @person.spouse.name if @person && @person.spouse
    # logger.debug "New post: #{user.inspect}"
    # #从 2.0 版本开始，Rails 内置了调试功能。在任何 Rails 程序中都可以使用 debugger 方法调出调试器。
    # byebug 
    # if !user
    #   user=User.create(name:"admin",password:"123456")
    #   user.save
    # end
  	if user.try(:authenticate, params[:password])
      #会话固定攻击的对策 
      reset_session
      #TODO 这边cart与user应该关联起来
  		session[:user_id] = user.id
      session[:cart_id] = @cart.id
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
    # session[:cart_id] = nil
  	redirect_to store_index_url,notice: "Logged out"
  end
end
