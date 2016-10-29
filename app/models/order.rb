class Order < ApplicationRecord
	has_many :line_items, dependent: :destroy
	enum pay_type:{
		"微信支付" => 0,
		"支付宝支付" => 1,
		"paypal支付" => 2
	}
	validates :name, :address, :email, presence: true
	validates :pay_type, inclusion: PaymentType.names


	def add_line_items_from_cart(cart)
		cart.line_items.each do |item|
			item.cart_id = nil 
			line_items << item
		end
		#self.line_items = cart.line_items
	end
end
