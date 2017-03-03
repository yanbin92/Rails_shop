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
  #
  #断言  作用
  # assert( test, [msg] )
  # 确保 test 是真值。
  # assert_not( test, [msg] )
  # 确保 test 是假值。
  # assert_equal( expected, actual, [msg] )
  # 确保 expected == actual 成立。
  # assert_not_equal( expected, actual, [msg] )
  # 确保 expected != actual 成立。
  # assert_same( expected, actual, [msg] )
  # 确保 expected.equal?(actual) 成立。
  # assert_not_same( expected, actual, [msg] )
  # 确保 expected.equal?(actual) 不成立。
  # assert_nil( obj, [msg] )
  # 确保 obj.nil? 成立。
  # assert_not_nil( obj, [msg] )
  # 确保 obj.nil? 不成立。
  # assert_empty( obj, [msg] )
  # 确保 obj 是空的。
  # assert_not_empty( obj, [msg] )
  # 确保 obj 不是空的。
  # assert_match( regexp, string, [msg] )
  # 确保字符串匹配正则表达式。
  # assert_no_match( regexp, string, [msg] )
  # 确保字符串不匹配正则表达式。
  # assert_includes( collection, obj, [msg] )
  # 确保 obj 在 collection 中。
  # assert_not_includes( collection, obj, [msg] )
  # 确保 obj 不在 collection 中。
  # assert_in_delta( expected, actual, [delta], [msg] )
  # 确保 expected 和 actual 的差值在 delta 的范围内。
  # assert_not_in_delta( expected, actual, [delta], [msg] )
  # 确保 expected 和 actual 的差值不在 delta 的范围内。
  # assert_throws( symbol, [msg] ) { block }
  # 确保指定的块会抛出指定符号表示的异常。
  # assert_raises( exception1, exception2, …​ ) { block }
  # 确保指定块会抛出指定异常中的一个。
  # assert_nothing_raised { block }
  # 确保指定的块不会抛出任何异常。
  # assert_instance_of( class, obj, [msg] )
  # 确保 obj 是 class 的实例。
  # assert_not_instance_of( class, obj, [msg] )
  # 确保 obj 不是 class 的实例。
  # assert_kind_of( class, obj, [msg] )
  # 确保 obj 是 class 或其后代的实例。
  # assert_not_kind_of( class, obj, [msg] )
  # 确保 obj 不是 class 或其后代的实例。
  # assert_respond_to( obj, symbol, [msg] )
  # 确保 obj 能响应 symbol 对应的方法。
  # assert_not_respond_to( obj, symbol, [msg] )
  # 确保 obj 不能响应 symbol 对应的方法。
  # assert_operator( obj1, operator, [obj2], [msg] )
  # 确保 obj1.operator(obj2) 成立。
  # assert_not_operator( obj1, operator, [obj2], [msg] )
  # 确保 obj1.operator(obj2) 不成立。
  # assert_predicate( obj, predicate, [msg] )
  # 确保 obj.predicate 为真，例如 assert_predicate str, :empty?。
  # assert_not_predicate( obj, predicate, [msg] )
  # 确保 obj.predicate 为假，例如 assert_not_predicate str, :empty?。
  # assert_send( array, [msg] )
  # 确保能在 array[0] 对应的对象上调用 array[1] 对应的方法，并且传入 array[2] 之后的值作为参数，例如 assert_send [@user, :full_name, 'Sam Smith']。很独特吧？
  # flunk( [msg] )
  # 确保失败。可以用这个断言明确标记未完成的测试。
  # 以上是 Minitest 支持的部分断言，完整且最新的列表参见 Minitest API 文档，尤其是 Minitest::Assertions 模块的文档
end