ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all
  # login_url = 
  # logout_url = '/logout'
  #测试方法以随机顺序执行。测试顺序可以使用 config.active_support.test_order 选项配置。
  #我们先编写一个测试检查所需的功能，它失败了，然后我们编写代码，添加功能，最后确认测试能通过。这种开发软件的方式叫做测试驱动开发（Test-Driven Development，TDD
  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  def login_as(user)
    post '/login', params: {name: user.name, password: 'secret'}
  end

  def logout
    delete '/logout'
  end

  def setup
    login_as(users(:one))
  end 

end