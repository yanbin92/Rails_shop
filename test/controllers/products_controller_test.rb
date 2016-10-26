require 'test_helper'

class ProductsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @product = products(:one)
    @update = {
     title: 'Lorem Ipsum',
     description: 'Wibbles are fun!',
     image_url: 'lorem.jpg',
     price: 19.95
   }
 end

 test "should get index" do
  get products_url
  assert_response :success
end

test "should get new" do
  get new_product_url
  assert_response :success
end

test "should create product" do
  assert_difference('Product.count') do
    post products_url, params: { product: @update }
  end

  assert_redirected_to product_url(Product.last)
end

test "should show product" do
  get product_url(@product)
  assert_response :success
end

test "should get edit" do
  get edit_product_url(@product)
  assert_response :success
end

test "should update product" do
  patch product_url(@product), params: { product: @update }#{ description: @product.description, image_url: @product.image_url, price: @product.price, title: @product.title } }
  assert_redirected_to product_url(@product)
end

test "assert_select method" do

    get products_url
    assert_response :success
  #     # At least one form element
  #   assert_select "form"

  #   # Form element includes four input fields
  #   assert_select "form input", 4

  #   # Page title is "Welcome"
  #   assert_select "title", "Welcome"

  #   # Page title is "Welcome" and there is only one title element
  #   assert_select "title", {count: 1, text: "Welcome"},
  #       "Wrong title or more than one title element"

  #   # Page contains no forms
  #   assert_select "form", false, "This page must contain no forms"

  #   # Test the content and style
  #   assert_select "body div.header ul.menu"

  #   # Use substitution values
  #   assert_select "ol>li#?", /item-\d+/

  #   # All input fields in the form have a name
  #   assert_select "form input" do
  #     assert_select "[name=?]", /.+/  # Not empty

  #       # Selects all div tags
  #     divs = css_select("div")

  #     # Selects all paragraph tags and does something interesting
  #     pars = css_select("p")
  #     pars.each do |par|
  #       # Do something fun with paragraphs here...
  #     end

  #     # Selects all list items in unordered lists
  #     items = css_select("ul>li")

  #     # Selects all form tags and then all inputs inside the form
  #     forms = css_select("form")
  #     forms.each do |form|
  #       inputs = css_select(form, "input")
  #     end
  # end 

end

test "can't delete product in cart" do
  assert_difference('Product.count',0) do 
    delete product_url(products(:two))
  end

  assert_redirected_to products_url
end


test "should destroy product" do
  assert_difference('Product.count', -1) do
    delete product_url(@product)
  end

  assert_redirected_to products_url
end
end
