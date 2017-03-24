class Rails::MyHelperGenerator < Rails::Generators::NamedBase
  def create_helper_file
  	create_file "app/helpers/#{file_name}_helper.rb", <<-FILE
  module #{class_name}Helper
  	attr_render :#{plural_name},:#{plural_name.singularize}
  end
  FILE
  end

  #如果再调用这个辅助方法生成器，而且配置的测试框架是 TestUnit，
  #它会调用 Rails::TestUnitGenerator 和 TestUnit::MyHelperGenerator。
  #这两个生成器都没定义，我们可以告诉生成器去调用 TestUnit::Generators::HelperGenerator。这个生成器是 Rails 自带的。为此，我们只需添加：
  hook_for :test_framework, as: :helper
end
