class PaymentType < ApplicationRecord
	def self.names
		all.collect{|payment_type|   #all指的是db 下的seeds中的数据
			payment_type.name
		}
	end
end
