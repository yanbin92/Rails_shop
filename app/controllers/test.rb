# try就好比Object#send，只不过如果接收者为nil，那么返回值也会是nil。

# 看下这个例子：

# 不使用 try
unless @number.nil?
  @number.next
end
 
# 使用 try
@number.try(:next)

#调用try时也可以不传参数而是用代码快，其中的代码只有在对象不为nil时才会执行：

@person.try { |p| "#{p.first_name} #{p.last_name}" }

class User
  def to_param
    "#{id}-#{name.parameterize}"
  end
end

#with_options方法可以为一组方法调用提取出共有的选项。

若要去除下述代码的重复内容：

class Account < ActiveRecord::Base
  has_many :customers, dependent: :destroy
  has_many :products,  dependent: :destroy
  has_many :invoices,  dependent: :destroy
  has_many :expenses,  dependent: :destroy
end

class Account < ActiveRecord::Base
  with_options dependent: :destroy do |assoc|
    assoc.has_many :customers
    assoc.has_many :products
    assoc.has_many :invoices
    assoc.has_many :expenses
  end
end

#in? 用于测试一个对象是否被包含在另一个对象里
25.in?(30..50)      # => false
1.in?(1)            # => ArgumentError

# Method Delegation
class User < ActiveRecord::Base
  has_one :profile
 

  delegate :name, :age, :address, :twitter, to: :profile
end