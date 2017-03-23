class InitializerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def copy_initializer_file
  	copy_file "initializer.rb", "config/initializers/#{file_name}.rb"
  end
end
# 首先注意，我们继承的是 Rails::Generators::NamedBase，
# 而不是 Rails::Generators::Base。这表明，我们的生成器至少需要一个参数，即初始化脚本的名称，在代码中通过 name 变量获取
# class InitializerGenerator < Rails::Generators::Base
#   desc "This generator creates an initializer file at config/initializers"
#   def create_initializer_file
#     create_file "config/initializers/initializer.rb", "# 这里是初始化文件的内容"
#   end
# end
