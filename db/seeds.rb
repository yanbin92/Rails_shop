# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
# test data 
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Product.delete_all
# . . .
Product.create(title: 'Seven Mobile Apps in Seven Weeks',
description:
%{<p>
<em>Native Apps, Multiple Platforms</em>
Answer the question “Can we build this for ALL the devices?” with a
resounding YES. This book will help you get there with a real-world
introduction to seven platforms, whether you’re new to mobile or an
experienced developer needing to expand your options. Plus, you’ll find
out which cross-platform solution makes the most sense for your needs.
</p>},
image_url: 'ruby.jpg',
price: 26.00)
# . . .
Product.create(title: 'Agile Web Development with Rails',
description:
%{<p>
<em>
Each of the tutorial chapters in the fifth edition of Agile Web Development with Rails ends with a small set of additional exercises—things for readers to play with.
</em>
Use the pages below to discuss your solutions, problems you encountered, and so on.

Enjoy exploring the various corners of Rails!
</p>},
image_url: 'rails.jpg',
price: 186.00)
#"微信支付" => 0,
#		"支付宝支付" => 1,
#		"paypal支付" => 2
PaymentType.delete_all
PaymentType.create([{:name => "paypal支付"},
	{:name => "微信支付"},
	{:name => "支付宝支付"}
]
	)

User.delete_all
User.create(name:"admin",password:"123456")
User.create(name:"yanbin",password:"123456")

#PaymentType.create() #自动保存到数据库 an_order= Order.new 
					#an_order.name="DaveThomas" ...an_order.save

