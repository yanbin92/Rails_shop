Order.transaction do  #rails runner script/creditcard.rb

	(1..100).each do |i|
		Order.create(name: "Customer #{i}",address: "#{i} Main Streat",
			email: "customer-#{i}@example.com",pay_type: "微信支付")
	end
end