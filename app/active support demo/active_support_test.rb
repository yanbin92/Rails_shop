# # try就好比Object#send，只不过如果接收者为nil，那么返回值也会是nil。

# # 看下这个例子：

# # 不使用 try
# unless @number.nil?
#   @number.next
# end
 
# # 使用 try
# @number.try(:next)

# #调用try时也可以不传参数而是用代码快，其中的代码只有在对象不为nil时才会执行：

# @person.try { |p| "#{p.first_name} #{p.last_name}" }

# class User
#   def to_param
#     "#{id}-#{name.parameterize}"
#   end
# end

# #with_options方法可以为一组方法调用提取出共有的选项。

# 若要去除下述代码的重复内容：

# class Account < ActiveRecord::Base
#   has_many :customers, dependent: :destroy
#   has_many :products,  dependent: :destroy
#   has_many :invoices,  dependent: :destroy
#   has_many :expenses,  dependent: :destroy
# end

# class Account < ActiveRecord::Base
#   with_options dependent: :destroy do |assoc|
#     assoc.has_many :customers
#     assoc.has_many :products
#     assoc.has_many :invoices
#     assoc.has_many :expenses
#   end
# end

# #in? 用于测试一个对象是否被包含在另一个对象里
# 25.in?(30..50)      # => false
# 1.in?(1)            # => ArgumentError

# # Method Delegation
# class User < ActiveRecord::Base
#   has_one :profile
 

#   delegate :name, :age, :address, :twitter, to: :profile
# end

# "hello".at(0)  # => "h"
# "hello".at(4)  # => "o"
# "hello".at(-1) # => "o"
# "hello".at(10) # => nil

# "hello".from(0)  # => "hello"
# "hello".from(2)  # => "llo"
# "hello".from(-2) # => "lo"
# "hello".from(10) # => "" if < 1.9, nil in 1.9

# "hello".to(0)  # => "h"
# "hello".to(2)  # => "hel"
# "hello".to(-2) # => "hell"
# "hello".to(10) # => "hello"

#  #Extensions to Enumerable
# [1, 2, 3].sum # => 6

# # Adding Elements
# #prepend

# #This method is an alias of Array#unshift.

# %w(a b c d).prepend('e')  # => %w(e a b c d)
# [].prepend(10)            # => [10]

# %w(a b c d).append('e')  # => %w(a b c d e)

# User.exists?(email: params[:email])

# [0, 1, -5, 1, 1, "foo", "bar"].split(1)
# # => [[0], [-5], [], ["foo", "bar"]]
# #  Extensions to Hash
# # 11.1 Conversions
# # 11.1.1 to_xml

# # The method to_xml returns a string containing an XML representation of its receiver:

# {"foo" => 1, "bar" => 2}.to_xml
# {a: 1, b: 2}.except(:a) # => {:b=>2}

# {nil => nil, 1 => 1, a: :a}.transform_keys { |key| key.to_s.upcase }

# {a: 1, b: 2, c: 3}.slice(:a, :c)
# # => {:c=>3, :a=>1}
#  
# {a: 1, b: 2, c: 3}.slice(:b, :X)
# # => {:b=>2} # non-existing keys are ignored

# (Date.today..Date.tomorrow).to_s

# (1..10).include?(3..7)  # => true


# d = Date.current
# # => Mon, 09 Aug 2010
# d + 1.year
# # => Tue, 09 Aug 2011
# d - 3.hours
# # => Sun, 08 Aug 2010 21:00:00 UTC +00:00

# date = Date.new(2010, 6, 7)
# date.beginning_of_day # => Mon Jun 07 00:00:00 +0200 2010

# #Extensions to DateTime

# # yesterday
# # tomorrow
# # beginning_of_week (at_beginning_of_week)
# # end_of_week (at_end_of_week)
# # monday
# # sunday
# # weeks_ago
# # prev_week (last_week)
# # next_week
# # months_ago
# # months_since
# # beginning_of_month (at_beginning_of_month)
# # end_of_month (at_end_of_month)
# # prev_month (last_month)
# # next_month
# # beginning_of_quarter (at_beginning_of_quarter)
# # end_of_quarter (at_end_of_quarter)
# # beginning_of_year (at_beginning_of_year)
# # end_of_year (at_end_of_year)
# # years_ago
# # years_since
# # prev_year (last_year)
# # next_year

# DateTime.current

# now = Time.current
# # => Mon, 09 Aug 2010 23:20:05 UTC +00:00
# now.all_day
# # => Mon, 09 Aug 2010 00:00:00 UTC +00:00..Mon, 09 Aug 2010 23:59:59 UTC +00:00

#  #Extensions to File

#  File.atomic_write(joined_asset_path) do |cache|
#   cache.write(join_asset_file_contents(asset_paths))
# end

#  #Marshal 的扩展

# # Active Support 为 load 增加了常量自动加载功能。
# File.open(file_name) { |f| Marshal.load(f) }

# # NameError 的扩展
# # Active Support 为 NameError 增加了 missing_name? 方法，测试异常是不是由于参数的名称引起的。

# # 参数的名称可以使用符号或字符串指定。指定符号时，使用裸常量名测试；指定字符串时，使用完全限定常量名测试。

# # 提示
# # 符号可以表示完全限定常量名，例如 :"ActiveRecord::Base"，因此这里符号的行为是为了便利而特别定义的，不是说在技术上只能如此。
# # 例如，调用 ArticlesController 的动作时，Rails 会乐观地使用 ArticlesHelper。如果那个模块不存在也没关系，因此，由那个常量名引起的异常要静默。不过，可能是由于确实是未知的常量名而由 articles_helper.rb 抛出的 NameError 异常。此时，异常应该抛出。missing_name? 方法能区分这两种情况：

# def default_helper_module!
#   module_name = name.sub(/Controller$/, '')
#   module_path = module_name.underscore
#   helper module_path
# rescue LoadError => e
#   raise e unless e.is_missing? "helpers/#{module_path}_helper"
# rescue NameError => e
#   raise e unless e.missing_name? "#{module_name}Helper"
# end

