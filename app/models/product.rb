class Product < ApplicationRecord
	has_many :line_items ,inverse_of :product #  如果要验证关联的对象是否存在 需要指定inverse_of 选项  在lin_items中指定 validates :
	has_many :orders,through: :line_items

	before_destroy :ensure_not_referenced_by_any_line_ltem #注册回调  对象生命周期时刻执行的方法
	#before_create do
	#  代码块  可用的回调见文档  before_validation  ....
	#after_initialize  after_find 从数据库中读取记录时执行  同时则after_find先执行 after_initialize 后  

	####终止回调  整个回调链是一个事务中 如果任何一个before_*回调方法返回false或抛出异常  整个回调链终止  而after_*只有抛出异常会造成此效果  可以和条件if: unless: 连用 见文档   
	#end

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
