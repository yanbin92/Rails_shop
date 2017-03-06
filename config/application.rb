require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Haitaoshop
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
    config.autoload_paths += %w(#{Rails.root}/lib)
    config.active_record.schema_format = :sql
    # 一个应用的 :host 参数一般是不变的，可以在 config/application.rb 文件中做全局配置：
    config.action_mailer.default_url_options = { host: 'example.com' }  
    
	# The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
	# config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
	# config.i18n.default_locale = :de
	#ctive Job 为多种队列后端（Sidekiq、Resque、Delayed Job，等等）内置了适配器。最新的适配器列表参见 ActiveJob::QueueAdapters 的 API 文档。
	# 要把适配器的 gem 写入 Gemfile
	# 请参照适配器的具体安装和部署说明
    # config.active_job.queue_adapter = :sidekiq
    
  end
end
