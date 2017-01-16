class Cart < ApplicationRecord
	has_many :line_items,dependent: :destroy
   validates_associated :line_items #默认错误消息为 is invalid
    #如果喝其他模型关联 要验证关联的对象 会在关联的对象上调用 valid? 方法 可以使用这个方法  ＃＃＃＃不要在关联的两端都适用validates_associated 会无限循环！！
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
      