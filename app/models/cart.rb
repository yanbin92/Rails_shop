class Cart < ApplicationRecord
	has_many :line_items,dependent: :destroy
   #如果模型和其他模型有关联，而且关联的模型也要验证，要使用这个辅助方法。保存对象时，会在相关联的每个对象上调用 valid? 方法 可以使用这个方法  ＃＃＃＃不要在关联的两端都适用validates_associated 会无限循环！！
   validates_associated :line_items #默认错误消息为 is invalid
	#cart= Cart.find(...)
   	#puts"Thiscarthas #{ cart.line_items.count} line items"

   	def add_product(product)
   		current_item = line_items.find_by(product_id: product.id)
   		if(current_item)
   			current_item.quantity += 1
   		else
   			current_item = line_items.build(product_id: product.id)
            current_item.price = product.price
   		end
   		current_item
   	end

      def total_price
         line_items.to_a.sum{|item|
            item.total_price 
         }
      end
end
      