require 'test_helper'

class CartTest < ActiveSupport::TestCase
   def new_cart_with_one_product(product_name)
   	cart = Cart.create
   	cart.add_product(products(product_name))
   	cart
   end

   test "cart should create a new line item when adding a new product" do
     cart = new_cart_with_one_product(:one)
     assert_equal 1,cart.line_items.count

     #add a new product
     cart.add_product(products(:ruby))
     assert_equal 2,cart.line_items.count
   end



  test 'cart should update an existing line item when adding an existing product' do
    cart = new_cart_with_one_product(:one)
    # Re-add the same product
    cart.add_product(products(:one))
    assert_equal 1, cart.line_items.count
  end
end
