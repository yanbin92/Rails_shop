Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # Code is not reloaded between requests.
  config.cache_classes = true

  # Eager load code on boot. This eager loads most of Rails and
  # your application in memory, allowing both threaded web servers
  # and those relying on copy on write to perform better.
  # Rake tasks automatically ignore this option for performance.
  config.eager_load = true

  # Full error reports are disabled and caching is turned on.
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true

  # Disable serving static files from the `/public` folder by default since
  # Apache or NGINX already handles this.
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?

  # Compress JavaScripts and CSS.
  #可以分别为 CSS 和 JavaScript 静态资源文件设置压缩方式
  config.assets.js_compressor = :uglifier
  # config.assets.css_compressor = :sass
  #如果 Gemfile 中包含 sass-rails gem，Rails 就会自动使用这个 gem 压缩 CSS 静态资源文件，而无需设置 config.assets.css_compressor 选项。

  # Do not fallback to assets pipeline if a precompiled asset is missed.
=begin
在某些情况下，我们需要使用实时编译。在实时编译模式下，Asset Pipeline 中的所有静态资源文件都由 Sprockets 直接处理。
    通过如下设置可以启用实时编译：
    config.assets.compile = true
    如前文所述，静态资源文件会在首次请求时被编译和缓存，辅助方法会把清单文件中的文件名转换为带 SHA256 哈希值的版本。
    Sprockets 还会把 Cache-Control HTTP 首部设置为 max-age=31536000，
    意思是服务器和客户端浏览器的所有缓存的过期时间是 1 年。
    这样在本地浏览器缓存或中间缓存中找到所需静态资源文件的可能性会大大增加，从而减少从服务器上获取静态资源文件的请求次数。
   但是实时编译模式会使用更多内存，性能也比默认设置更差，因此并不推荐使用。
=end
  config.assets.compile = true

  # `config.assets.precompile` and `config.assets.version` have moved to config/initializers/assets.rb

  # Enable serving of images, stylesheets, and JavaScripts from an asset server.
  # config.action_controller.asset_host = 'http://assets.example.com'


  # Specifies the header that your server uses for sending files.
  # config.action_dispatch.x_sendfile_header = 'X-Sendfile' # for Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for NGINX

  # Mount Action Cable outside main process or domain
  #config.action_cable.mount_path 选项指定监听路径
  # config.action_cable.mount_path = nil
  # 要想配置 URL 地址，可以在 HTML 布局文件的 <head> 元素中添加 action_cable_meta_tag 标签。这个标签会使用环境配置文件中 config.action_cable.url 选项设置的 URL 地址或路径。
  # config.action_cable.url = 'wss://example.com/cable'
  # config.action_cable.allowed_request_origins = [ 'http://example.com', /http:\/\/example.*/ ]
  #应用于每个连接记录器的日志标签 关于所有配置选项的完整列表，请参阅 ActionCable::Server::Configuration 类的 API 文档。
  # config.action_cable.log_tags = [
  #   -> request { request.env['bc.account_id'] || "no-account" },
  #   :action_cable,
  #   -> request { request.uuid }
  # ]

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  #在不安全的网络中嗅探 cookie。无线局域网就是一个例子。在未加密的无线局域网中，监听所有已连接客户端的流量极其容易。因此，Web 应用开发者应该通过 SSL 提供安全连接。在 Rails 3.1 和更高版本中，可以在应用配置文件中设置强制使用 SSL 连接：

  #强制所有请求经由 ActionDispatch::SSL 中间件处理，即通过 HTTPS 伺服，而且把 config.action_mailer.default_url_options 设为 { protocol: 'https' }。SSL 通过设定 config.ssl_options 选项配置
  config.force_ssl = true
 
  # Use the lowest log level to ensure availability of diagnostic information
  # when problems arise.
  config.log_level = :debug

  # Prepend all log lines with the following tags.
  config.log_tags = [ :request_id ]

  # Use a different cache store in production.
  # config.cache_store = :mem_cache_store

  # Use a real queuing backend for Active Job (and separate queues per environment)
  # config.active_job.queue_adapter     = :resque
  # config.active_job.queue_name_prefix = "haitaoshop_#{Rails.env}"
  config.action_mailer.perform_caching = false

  # Ignore bad email addresses and do not raise email delivery errors.
  # Set this to true and configure the email server for immediate delivery to raise delivery errors.
  # config.action_mailer.raise_delivery_errors = false

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation cannot be found).
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners.
  config.active_support.deprecation = :notify

  # Use default logging formatter so that PID and timestamp are not suppressed.
  config.log_formatter = ::Logger::Formatter.new

  # Use a different logger for distributed setups.
  # require 'syslog/logger'
  # config.logger = ActiveSupport::TaggedLogging.new(Syslog::Logger.new 'app-name')

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger = ActiveSupport::TaggedLogging.new(logger)
  end

  # Do not dump schema after migrations.
  config.active_record.dump_schema_after_migration = false
  #X-Sendfile 首部

  #X-Sendfile 首部的作用是让 Web 服务器忽略应用对请求的响应，直接返回磁盘中的指定文件。默认情况下 Rails 不会发送这个首部，但在支持这个首部的服务器上可以启用这一特性，以提供更快的响应速度。
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # 用于 Apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # 用于 NGINX
end
