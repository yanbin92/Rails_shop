class Order < ApplicationRecord
	has_many :line_items, dependent: :destroy
	#enum pay_type:{
	##	"微信支付" => 0,
	#	"支付宝支付" => 1,
	#	"paypal支付" => 2
	#}
	validates :name, :address, :email, presence: true #if： 条件验证 
	#自定义验证方式  示例  validate_each 见文档
	class MyValidator < ActiveModel::Validator
		def validate(record)
			# unless record.name.starts_with?'X'
			# 	record.errors[:name] << "Need a name starting with X please!"
			# end
		end
	end
	include ActiveModel::Validations
	validates_with MyValidator

	validates :pay_type, inclusion: PaymentType.names  

	#exclusion  与inclusion  哪些值不是某个属性的选择值  validates :pay_type,exclusion: {in: %w{www us ou jp}}
	validates_each :pay_type do |model, attr, value|#validates_each 会将属性值传入代码库做验证  没有
  	  if !PaymentType.names.include?(value)
    	model.errors.add(attr, "Payment type not on the list") 
	  end
	end



	def add_line_items_from_cart(cart)
		cart.line_items.each do |item|
			item.cart_id = nil 
			line_items << item
		end
		#self.line_items = cart.line_items
	end


	def get_city_statistics
		run_with_index(:city) do
		# .. calculate stats
		
		end
	end

	#However,that index isn’t needed during the day-to-day running of the application, and  tests have shown that maintaining it slows the application appreciably

	def run_with_index(*columns)
		connection.add_index(:orders, *columns)
		begin
			yield
		ensure
			connection.remove_index(:orders, *columns)
		end
	end

	# scope 函数
	scope :check,-> {where(pay_type: "微信支付")}
end
