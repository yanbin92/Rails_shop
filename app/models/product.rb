class Product < ApplicationRecord
	has_many :line_items ,inverse_of :product #  如果要验证关联的对象是否存在 需要指定inverse_of 选项 inverse_of 选项意义注意见Record 关联文档 在lin_items中指定 validates :
	has_many :orders,through: :line_items   #关联的作用 文档有讲的清楚 模型之间有关系  方便级联删除等操作 
	#has_many :orders,through:   多对多关联  has_many 1对多关联  has_one  1对1          
	#自连接   有点意思  使用方式 见文档 下面是示例   
	# class Employee < ApplicationRecord
	# 	has_many :subordinates, class_name: "Employee",
	# 							foreign_key: "manager_id"
	# 	belongs_to :manager,class_name: "Employee"

	# end
	#多态关联  :ploymorphic  true
	#touch: true    保存或销魂对象时  关联对象的updated_at 会自动设为当前时间戳  见文档

	before_destroy :ensure_not_referenced_by_any_line_ltem #注册回调  对象生命周期时刻执行的方法
	#before_create do
	#  代码块  可用的回调见文档  before_validation  ....
	#after_initialize  after_find 从数据库中读取记录时执行  同时则after_find先执行 after_initialize 后  

	####终止回调  整个回调链是一个事务中 如果任何一个before_*回调方法返回false或抛出异常  整个回调链终止  而after_*只有抛出异常会造成此效果  可以和条件if: unless: 连用 见文档   
	#end
	#回调类 

	# class MyCallBack
	# 	def after_destory
	# 		puts 'callback destory '
	# 	end
		# def self.after_destory
		# 	puts 'callback destory '
		# end 

	# end

	# after_destory MyCallBack.new   如果定义为类方法更好 就不需要实例化  
	# after_commit after_rollback 会在事务完成时触发  这两个回调如果抛出异常 会被忽略 不会干扰其他回调  

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
