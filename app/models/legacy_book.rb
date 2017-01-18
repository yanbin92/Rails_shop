class LegacyBook < ApplicationRecord
	self.primary_key = "isbn" #  test  覆盖默认的主键id

	# book= LegacyBook.new  即使设置了主键为isbn 仍然能使用id= 给isbn赋值
	# book.id="0-12345-6789"
	# book.title="My GreatAmericanNovel"
	# book.save
	# # ...
	# book= LegacyBook.find("0-12345-6789")
	# puts book.title # => "My Great American Novel"
	# p book.attributes #=> {"isbn" =>"0-12345-6789",
	# 				#"title"=>"MyGreatAmericanNovel"}

end
