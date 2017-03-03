require 'test_helper'
#集成测试 集成测试用于测试应用中不同部分之间的交互，一般用于测试应用中重要的工作流程。
#rails generate integration_test user_flows
class UserStoriesTest < ActionDispatch::IntegrationTest
  # 集成测试运行程序的说明参阅 ActionDispatch::Integration::Runner 模块的文档。
  # 执行请求的方法参见 ActionDispatch::Integration::RequestHelpers 模块的文档。
  # 如果需要修改会话或集成测试的状态，参阅 ActionDispatch::Integration::Session 类的文档。
  fixtures :products
  include ActiveJob::TestHelper

  test "buy a product" do
	 start_order_count = Order.count
	 ruby_book = products(:ruby)

	  #index
	  get "/"
	  assert_response :success
	  assert_select 'h1', "Your Progmatic Catalog"
	  #add to cart  xhr  xml http request
	  post '/line_items', params: { product_id: ruby_book.id }, xhr: true
	  assert_response :success
	  cart = Cart.find(session[:cart_id])
	  assert_equal 1, cart.line_items.size
	  assert_equal ruby_book, cart.line_items[0].product
	  #check out cart
	  get "/orders/new"
	  assert_response :success
	  assert_select 'legend', 'Please Enter Your Details'
	  #add order info
	  perform_enqueued_jobs do
		  post "/orders", params: {
			order: {
			name: "Alien",
			address: "123 The Street",
			email: "178266871@qq.com",
			pay_type: "微信支付"
			}
		   }
		   assert_response :redirect
		   follow_redirect! #重定向后如果还想发送请求，别忘了调用 follow_redirect!。
		   assert_response :success
		   assert_select 'h1', "Your Progmatic Catalog"
		   cart = Cart.find(session[:cart_id])
		   assert_equal 0, cart.line_items.size
		   #enter db , 
		   assert_equal start_order_count + 1, Order.count
		   order = Order.last
			assert_equal "Alien", order.name
			assert_equal "123 The Street", order.address
			assert_equal "178266871@qq.com", order.email
			assert_equal "微信支付", order.pay_type
			assert_equal 1, order.line_items.size
			line_item = order.line_items[0]
			assert_equal ruby_book, line_item.product

			# verify that the mail itself is correctly addressed and has the expected subject line:
			mail = ActionMailer::Base.deliveries.last
			assert_equal ["ybinbin@outlook.com"], mail.to
			assert_equal 'Haitao shop <ybinbin@example.com>', mail[:from].value
			assert_equal "Pragmatic Store Order Confirmation", mail.subject
  		end
  end

end