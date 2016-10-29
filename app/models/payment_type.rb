class PaymentType < ApplicationRecord
	def self.names
		all.collect{|payment_type|
			payment_type.name
		}
	end
end
