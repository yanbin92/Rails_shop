class LegacyBook < ApplicationRecord
	self.primary_key = "isbn" #覆盖默认的主键id
end
