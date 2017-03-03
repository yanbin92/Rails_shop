require 'test_helper'#加载默认的测试配置

class CartTest < ActiveSupport::TestCase
   def new_cart_with_one_product(product_name)
   	cart = Cart.create
   	cart.add_product(products(product_name))
   	cart
   end
   #只要名称以 test_ 开头（区分大小写），就是一个“测试”。因此，名为 test_password 和 test_valid_password 的方法是有效的测试，运行测试用例时会自动运行
   #Rails 定义了 test 方法，它接受一个测试名称和一个块
   test "cart should create a new line item when adding a new product" do
     cart = new_cart_with_one_product(:one)
     # byebug
     assert_equal 1,cart.line_items.size

     #add a new product
     cart.add_product(products(:ruby))
     assert_equal 2,cart.line_items.size
   end



  test 'cart should update an existing line item when adding an existing product' do
    cart = new_cart_with_one_product(:one)
    # Re-add the same product
    cart.add_product(products(:one))
    assert_equal 1, cart.line_items.size
  end
end
