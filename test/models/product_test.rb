require 'test_helper'
#Unit Testing of Models
class ProductTest < ActiveSupport::TestCase
	fixtures :products #load fixtures
	#The name of the fixture file determines the table that’s loaded,
	# => so using :products will cause the products.yml fixture file to be used.

	test "the truth" do
		product=Product.new
		assert product.invalid?
		assert product.errors[:title].any?
		assert product.errors[:description].any?
		assert product.errors[:price].any?
		assert product.errors[:image_url].any?

	end

	test "product price must be positive" do
		product = Product.new(title: "My Book Title",
			description: "yyy",
			image_url: "zzz.jpg")
		product.price = -1
		assert product.invalid?
		assert_equal ["must be greater than or equal to 0.01"],
		product.errors[:price]
		product.price = 0
		assert product.invalid?
		assert_equal ["must be greater than or equal to 0.01"],
		product.errors[:price]
		product.price = 1
		assert product.valid?
	end

	def new_product(image_url)
		Product.new(title: "My Book Title",
			description: "yyy",
			price: 1,
			image_url: image_url)
	end

	test "image url" do
		ok = %w{ fred.gif fred.jpg fred.png FRED.JPG FRED.Jpg
			http://a.b.c/x/y/z/fred.gif }
		bad = %w{ fred.doc fred.gif/more fred.gif.more }
		ok.each do |name|
			assert new_product(name).valid?, "#{name} shouldn't be invalid"
		end
		bad.each do |name|
			assert new_product(name).invalid?, "#{name} shouldn't be valid"
		end
	end

	test "product is not valid without a unique title" do
		product = Product.new(title: products(:ruby).title,
		description: "yyy",
		price: 1,
		image_url: "fred.gif")
		assert product.invalid?
		assert_equal [I18n.translate('errors.messages.taken')],
		product.errors[:title]
		#
		#assert_equal ["has already been taken"], product.errors[:title]
	end

	def new_product_with_url(image_url)
 	Product.new(
	    title: "My Book Title",
	    description: "yyy",
	    price: 1,
	    image_url: image_url
  	)
	end

test "product is not valid without a unique image_url" do
  product = new_product_with_url(products(:ruby).image_url)
  assert !product.save
  assert_equal "has already been taken", product.errors[:image_url].join('; ')
end


end
