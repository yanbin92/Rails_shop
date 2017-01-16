class Product < ApplicationRecord
	has_many :line_items ,inverse_of :product #  如果要验证关联的对象是否存在 需要指定inverse_of 选项
	has_many :orders,through: :line_items
	before_destroy :ensure_not_referenced_by_any_line_ltem
	validates(:title,:description,:image_url,:presence => true)
	validates :price,:numericality=>{:greater_than_or_equal_to=>0.01}
	#numericality  检查属性的值是否包含数字  greater_than(_or_)equal_to less_than odd 奇数 even: true 偶数
	validates :title,:uniqueness=>true
	validates :image_url,allow_blank: true, :format=>{
		:with => %r{\.(gif|jpg|png|webp)\z}i,
		:message => 'must be a URL for gif,jpg,png,wbp'
	}   #format:  检查属性的值是否匹配  with 正则表达式 

    validates :image_url,uniqueness: true
    
	private 
		def ensure_not_referenced_by_any_line_ltem
			unless line_items.empty?
				errors.add(:base,'Line Items present')
				throw :abort
			end
		end
end
