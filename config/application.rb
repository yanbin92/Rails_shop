require_relative 'boot'
#在 Rails 之前运行代码
#虽然在加载 Rails 自身之前运行代码很少见，但是如果想这么做，可以把代码添加到 config/application.rb 文件中 require 'rails/all' 的前面
require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)
#初始化代码的存放位置
# Rails 为初始化代码提供了四个标准位置：

# config/application.rb

# 针对各环境的配置文件

# 初始化脚本

# 后置初始化脚本
module Haitaoshop
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    #接受一个路径数组，让 Rails 自动加载里面的常量。默认值是 app 目录中的全部子目录。
    config.autoload_paths += %w(#{Rails.root}/lib)
    config.active_record.schema_format = :sql
    # 一个应用的 :host 参数一般是不变的，可以在 config/application.rb 文件中做全局配置：
    config.action_mailer.default_url_options = { host: 'myrailsshop.herokuapp.com' }  
    #!!!!鉴于此，在邮件视图中不能使用任何 *_path 辅助方法，而要使用相应的 *_url 辅助方法
    #在邮件视图中添加图像 http://localhost:3000
    #config.asset_host 设定静态资源文件的主机名
    config.action_mailer.asset_host = 'http://myrailsshop.herokuapp.com'

  	# The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  	# config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
  	# config.i18n.default_locale = :de
  	#active Job 为多种队列后端（Sidekiq、Resque、Delayed Job，等等）内置了适配器。最新的适配器列表参见 ActiveJob::QueueAdapters 的 API 文档。
  	# 要把适配器的 gem 写入 Gemfile
  	# 请参照适配器的具体安装和部署说明
    # config.active_job.queue_adapter = :sidekiq 

    #config.cache_store 配置 Rails 缓存使用哪个存储器。可用的选项有：:memory_store、:file_store、:mem_cache_store、:null_store，或者实现了缓存 API 的对象。如果存在 tmp/cache 目录，默认值为 :file_store，否则为 :memory_store。   
    # 定制工作流程的第一步是，不让脚手架生成样式表、JavaScript 和测试固件文件
    # config.generators do |g|
    #   g.orm             :active_record
    #   g.template_engine :erb
    #   g.test_framework  :test_unit, fixture: false
    #   g.stylesheets     false
    #   g.javascripts     false
    # end
    #如果再使用脚手架生成器生成一个资源，你会看到，它不再创建样式表、JavaScript 和固件文件了。如果想进一步定制，例如使用 DataMapper 和 RSpec 替换 Active Record 和 TestUnit，只需添加相应的 gem，然后配置生成器。 
  end
end
