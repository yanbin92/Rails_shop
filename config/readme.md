#配置静态资源

config.assets.enabled 是个旗标，控制是否启用 Asset Pipeline。默认值为 true。

config.assets.raise_runtime_errors 设为 true 时启用额外的运行时错误检查。推荐在 config/environments/development.rb 中设定，以免部署到生产环境时遇到意料之外的错误。

config.assets.css_compressor 定义所用的 CSS 压缩程序。默认设为 sass-rails。目前唯一的另一个值是 :yui，使用 yui-compressor gem 压缩。

config.assets.js_compressor 定义所用的 JavaScript 压缩程序。可用的值有 :closure、:uglifier 和 :yui，分别使用 closure-compiler、uglifier 和 yui-compressor gem。

config.assets.gzip 是一个旗标，设定在静态资源的常规版本之外是否创建 gzip 版本。默认为 true。

config.assets.paths 包含查找静态资源的路径。在这个配置选项中追加的路径，会在里面寻找静态资源。

config.assets.precompile 设定运行 rake assets:precompile 任务时要预先编译的其他静态资源（除 application.css 和 application.js 之外）。

config.assets.prefix 定义伺服静态资源的前缀。默认为 /assets。

config.assets.manifest 定义静态资源预编译器使用的清单文件的完整路径。默认为 public 文件夹中 config.assets.prefix 设定的目录中的 manifest-<random>.json。

config.assets.digest 设定是否在静态资源的名称中包含 MD5 指纹。默认为 true。

config.assets.debug 禁止拼接和压缩静态文件。在 development.rb 文件中默认设为 true。

config.assets.compile 是一个旗标，设定在生产环境中是否启用实时 Sprockets 编译。

config.assets.logger 接受一个符合 Log4r 接口的日志记录器，或者默认的 Ruby Logger 类。默认值与 config.logger 相同。如果设为 false，不记录对静态资源的伺服。




配置生成器

Rails 允许通过 config.generators 方法调整生成器的行为。这个方法接受一个块：

config.generators do |g|
  g.orm :active_record
  g.test_framework :test_unit
end
在这个块中可以使用的全部方法如下：

assets 指定在生成脚手架时是否创建静态资源。默认为 true。

force_plural 指定模型名是否允许使用复数。默认为 false。

helper 指定是否生成辅助模块。默认为 true。

integration_tool 指定使用哪个集成工具生成集成测试。默认为 :test_unit。

javascripts 启用生成器中的 JavaScript 文件钩子。在 Rails 中供 scaffold 生成器使用。默认为 true。

javascript_engine 配置生成静态资源时使用的脚本引擎（如 coffee）。默认为 :js。

orm 指定使用哪个 ORM。默认为 false，即使用 Active Record。

resource_controller 指定 rails generate resource 使用哪个生成器生成控制器。默认为 :controller。

resource_route 指定是否生成资源路由。默认为 true。

scaffold_controller 与 resource_controller 不同，它指定 rails generate scaffold 使用哪个生成器生成脚手架中的控制器。默认为 :scaffold_controller。

stylesheets 启用生成器中的样式表钩子。在 Rails 中供 scaffold 生成器使用，不过也可以供其他生成器使用。默认为 true。

stylesheet_engine 配置生成静态资源时使用的样式表引擎（如 sass）。默认为 :css。

scaffold_stylesheet 生成脚手架中的资源时创建 scaffold.css。默认为 true。

test_framework 指定使用哪个测试框架。默认为 false，即使用 Minitest。

template_engine 指定使用哪个模板引擎，例如 ERB 或 Haml。默认为 :erb。


 配置中间件

每个 Rails 应用都自带一系列中间件，在开发环境中按下述顺序使用：

ActionDispatch::SSL 强制使用 HTTPS 伺服每个请求。config.force_ssl 设为 true 时启用。传给这个中间件的选项通过 config.ssl_options 配置。

ActionDispatch::Static 用于伺服静态资源。config.public_file_server.enabled 设为 false 时禁用。如果静态资源目录的索引文件不是 index，使用 config.public_file_server.index_name 指定。例如，请求目录时如果想伺服 main.html，而不是 index.html，把 config.public_file_server.index_name 设为 "main"。

ActionDispatch::Executor 以线程安全的方式重新加载代码。onfig.allow_concurrency 设为 false 时禁用，此时加载 Rack::Lock。Rack::Lock 把应用包装在 mutex 中，因此一次只能被一个线程调用。

ActiveSupport::Cache::Strategy::LocalCache 是基本的内存后端缓存。这个缓存对线程不安全，只应该用作单线程的临时内存缓存。

Rack::Runtime 设定 X-Runtime 首部，包含执行请求的时间（单位为秒）。

Rails::Rack::Logger 通知日志请求开始了。请求完成后，清空相关日志。

ActionDispatch::ShowExceptions 拯救应用抛出的任何异常，在本地或者把 config.consider_all_requests_local 设为 true 时渲染精美的异常页面。如果把 config.action_dispatch.show_exceptions 设为 false，异常总是抛出。

ActionDispatch::RequestId 在响应中添加 X-Request-Id 首部，并且启用 ActionDispatch::Request#uuid 方法。

ActionDispatch::RemoteIp 检查 IP 欺骗攻击，从请求首部中获取有效的 client_ip。可通过 config.action_dispatch.ip_spoofing_check 和 config.action_dispatch.trusted_proxies 配置。

Rack::Sendfile 截获从文件中伺服内容的响应，将其替换成服务器专属的 X-Sendfile 首部。可通过 config.action_dispatch.x_sendfile_header 配置。

ActionDispatch::Callbacks 在伺服请求之前运行准备回调。

ActiveRecord::ConnectionAdapters::ConnectionManagement 在每次请求后清理活跃的连接，除非请求环境的 rack.test 键为 true。

ActiveRecord::QueryCache 缓存请求中生成的所有 SELECT 查询。如果有 INSERT 或 UPDATE 查询，清空所有缓存。

ActionDispatch::Cookies 为请求设定 cookie。

ActionDispatch::Session::CookieStore 负责把会话存储在 cookie 中。可以把 config.action_controller.session_store 改为其他值，换成其他中间件。此外，可以使用 config.action_controller.session_options 配置传给这个中间件的选项。

ActionDispatch::Flash 设定 flash 键。仅当为 config.action_controller.session_store 设定值时可用。

Rack::MethodOverride 在设定了 params[:_method] 时允许覆盖请求方法。这是支持 PATCH、PUT 和 DELETE HTTP 请求的中间件。

Rack::Head 把 HEAD 请求转换成 GET 请求，然后以 GET 请求伺服。

除了这些常规中间件之外，还可以使用 config.middleware.use 方法添加：

config.middleware.use Magical::Unicorns
上述代码把 Magical::Unicorns 中间件添加到栈的末尾。如果想把中间件添加到另一个中间件的前面，可以使用 insert_before：

config.middleware.insert_before Rack::Head, Magical::Unicorns
此外，还有 insert_after。它把中间件添加到另一个中间件的后面：

config.middleware.insert_after Rack::Head, Magical::Unicorns
中间件也可以完全替换掉：

config.middleware.swap ActionController::Failsafe, Lifo::Failsafe
还可以从栈中移除：

config.middleware.delete Rack::MethodOverride



#配置 Active Record

config.active_record 包含众多配置选项：

config.active_record.logger 接受符合 Log4r 接口的日志记录器，或者默认的 Ruby Logger 类，然后传给新的数据库连接。可以在 Active Record 模型类或实例上调用 logger 方法获取日志记录器。设为 nil 时禁用日志。

config.active_record.primary_key_prefix_type 用于调整主键列的名称。默认情况下，Rails 假定主键列名为 id（无需配置）。此外有两个选择：

设为 :table_name 时，Customer 类的主键为 customerid。

设为 :table_name_with_underscore 时，Customer 类的主键为 customer_id。

config.active_record.table_name_prefix 设定一个全局字符串，放在表名前面。如果设为 northwest_，Customer 类对应的表是 northwest_customers。默认为空字符串。

config.active_record.table_name_suffix 设定一个全局字符串，放在表名后面。如果设为 _northwest，Customer 类对应的表是 customers_northwest。默认为空字符串。

config.active_record.schema_migrations_table_name 设定模式迁移表的名称。

config.active_record.pluralize_table_names 指定 Rails 在数据库中寻找单数还是复数表名。如果设为 true（默认），那么 Customer 类使用 customers 表。如果设为 false，Customer 类使用 customer 表。

config.active_record.default_timezone 设定从数据库中检索日期和时间时使用 Time.local（设为 :local 时）还是 Time.utc（设为 :utc 时）。默认为 :utc。

config.active_record.schema_format 控制把数据库模式转储到文件中时使用的格式。可用的值有：:ruby（默认），与所用的数据库无关；:sql，转储 SQL 语句（可能与数据库有关）。

config.active_record.error_on_ignored_order_or_limit 指定批量查询时如果忽略顺序或数量限制是否抛出错误。设为 true 时抛出错误，设为 false 时发出提醒。默认为 false。

config.active_record.timestamped_migrations 控制迁移使用整数还是时间戳编号。默认为 true，使用时间戳。如果有多个开发者共同开发同一个应用，建议这么设置。

config.active_record.lock_optimistically 控制 Active Record 是否使用乐观锁。默认为 true。

config.active_record.cache_timestamp_format 控制缓存键中时间戳的格式。默认为 :nsec。

config.active_record.record_timestamps 是个布尔值选项，控制 create 和 update 操作是否更新时间戳。默认值为 true。

config.active_record.partial_writes 是个布尔值选项，控制是否使用部分写入（partial write，即更新时是否只设定有变化的属性）。注意，使用部分写入时，还应该使用乐观锁（config.active_record.lock_optimistically），因为并发更新可能写入过期的属性。默认值为 true。

config.active_record.maintain_test_schema 是个布尔值选项，控制 Active Record 是否应该在运行测试时让测试数据库的模式与 db/schema.rb（或 db/structure.sql）保持一致。默认为 true。

config.active_record.dump_schema_after_migration 是个旗标，控制运行迁移后是否转储模式（db/schema.rb 或 db/structure.sql）。生成 Rails 应用时，config/environments/production.rb 文件中把它设为 false。如果不设定这个选项，默认为 true。

config.active_record.dump_schemas 控制运行 db:structure:dump 任务时转储哪些数据库模式。可用的值有：:schema_search_path（默认），转储 schema_search_path 列出的全部模式；:all，不考虑 schema_search_path，始终转储全部模式；以逗号分隔的模式字符串。

config.active_record.belongs_to_required_by_default 是个布尔值选项，控制没有 belongs_to 关联时记录的验证是否失败。

config.active_record.warn_on_records_fetched_greater_than 为查询结果的数量设定一个提醒阈值。如果查询返回的记录数量超过这一阈值，在日志中记录一个提醒。可用于标识可能导致内存泛用的查询。

config.active_record.index_nested_attribute_errors 让嵌套的 has_many 关联错误显示索引。默认为 false。

MySQL 适配器添加了一个配置选项：

ActiveRecord::ConnectionAdapters::Mysql2Adapter.emulate_booleans 控制 Active Record 是否把 tinyint(1) 类型的列当做布尔值。默认为 true。

模式转储程序添加了一个配置选项：

ActiveRecord::SchemaDumper.ignore_tables 指定一个表数组，不包含在生成的模式文件中。如果 config.active_record.schema_format 的值不是 :ruby，这个设置会被忽略。

# 配置 Action Controller

config.action_controller 包含众多配置选项：

config.action_controller.asset_host 设定静态资源的主机。不使用应用自身伺服静态资源，而是通过 CDN 伺服时设定。

config.action_controller.perform_caching 配置应用是否使用 Action Controller 组件提供的缓存功能。默认在开发环境中为 false，在生产环境中为 true。

config.action_controller.default_static_extension 配置缓存页面的扩展名。默认为 .html。

config.action_controller.include_all_helpers 配置视图辅助方法在任何地方都可用，还是只在相应的控制器中可用。如果设为 false，UsersHelper 模块中的方法只在 UsersController 的视图中可用。如果设为 true，UsersHelper 模块中的方法在任何地方都可用。默认的行为（不明确设为 true 或 false）是视图辅助方法在每个控制器中都可用。

config.action_controller.logger 接受符合 Log4r 接口的日志记录器，或者默认的 Ruby Logger 类，用于记录 Action Controller 的信息。设为 nil 时禁用日志。

config.action_controller.request_forgery_protection_token 设定请求伪造的令牌参数名称。调用 protect_from_forgery 默认把它设为 :authenticity_token。

config.action_controller.allow_forgery_protection 启用或禁用 CSRF 防护。在测试环境中默认为 false，其他环境默认为 true。

config.action_controller.forgery_protection_origin_check 配置是否检查 HTTP Origin 首部与网站的源一致，作为一道额外的 CSRF 防线。

config.action_controller.per_form_csrf_tokens 控制 CSRF 令牌是否只在生成它的方法（动作）中有效。

config.action_controller.relative_url_root 用于告诉 Rails 你把应用部署到子目录中。默认值为 ENV['RAILS_RELATIVE_URL_ROOT']。

config.action_controller.permit_all_parameters 设定默认允许批量赋值全部参数。默认值为 false。

config.action_controller.action_on_unpermitted_parameters 设定在发现没有允许的参数时记录日志还是抛出异常。设为 :log 或 :raise 时启用。开发和测试环境的默认值是 :log，其他环境的默认值是 false。

config.action_controller.always_permitted_parameters 设定一个参数白名单列表，默认始终允许。默认值是 ['controller', 'action']。

#配置 Action Dispatch

config.action_dispatch.session_store 设定存储会话数据的存储器。默认为 :cookie_store；其他有效的值包括 :active_record_store、:mem_cache_store 或自定义类的名称。

config.action_dispatch.default_headers 的值是一个散列，设定每个响应默认都有的 HTTP 首部。默认定义的首部有：

config.action_dispatch.default_headers = {
  'X-Frame-Options' => 'SAMEORIGIN',
  'X-XSS-Protection' => '1; mode=block',
  'X-Content-Type-Options' => 'nosniff'
}
config.action_dispatch.default_charset 指定渲染时使用的默认字符集。默认为 nil。

config.action_dispatch.tld_length 设定应用的 TLD（top-level domain，顶级域名）长度。默认为 1。

config.action_dispatch.http_auth_salt 设定 HTTP Auth 的盐值。默认为 'http authentication'。

config.action_dispatch.signed_cookie_salt 设定签名 cookie 的盐值。默认为 'signed cookie'。

config.action_dispatch.encrypted_cookie_salt 设定加密 cookie 的盐值。默认为 'encrypted cookie'。

config.action_dispatch.encrypted_signed_cookie_salt 设定签名加密 cookie 的盐值。默认为 'signed encrypted cookie'。

config.action_dispatch.perform_deep_munge 配置是否在参数上调用 deep_munge 方法。详情参见 19.8 节。默认为 true。

config.action_dispatch.rescue_responses 设定异常与 HTTP 状态的对应关系。其值为一个散列，指定异常和状态之间的映射。默认的定义如下：

config.action_dispatch.rescue_responses = {
  'ActionController::RoutingError'              => :not_found,
  'AbstractController::ActionNotFound'          => :not_found,
  'ActionController::MethodNotAllowed'          => :method_not_allowed,
  'ActionController::UnknownHttpMethod'         => :method_not_allowed,
  'ActionController::NotImplemented'            => :not_implemented,
  'ActionController::UnknownFormat'             => :not_acceptable,
  'ActionController::InvalidAuthenticityToken'  => :unprocessable_entity,
  'ActionController::InvalidCrossOriginRequest' => :unprocessable_entity,
  'ActionDispatch::ParamsParser::ParseError'    => :bad_request,
  'ActionController::BadRequest'                => :bad_request,
  'ActionController::ParameterMissing'          => :bad_request,
  'Rack::QueryParser::ParameterTypeError'       => :bad_request,
  'Rack::QueryParser::InvalidParameterError'    => :bad_request,
  'ActiveRecord::RecordNotFound'                => :not_found,
  'ActiveRecord::StaleObjectError'              => :conflict,
  'ActiveRecord::RecordInvalid'                 => :unprocessable_entity,
  'ActiveRecord::RecordNotSaved'                => :unprocessable_entity
}
没有配置的异常映射为 500 Internal Server Error。

ActionDispatch::Callbacks.before 接受一个代码块，在请求之前运行。

ActionDispatch::Callbacks.to_prepare 接受一个块，在 ActionDispatch::Callbacks.before 之后、请求之前运行。在开发环境中每个请求都会运行，但在生产环境或 cache_classes 设为 true 的环境中只运行一次。

ActionDispatch::Callbacks.after 接受一个代码块，在请求之后运行。

配置 Action View

config.action_view 有一些配置选项：

config.action_view.field_error_proc 提供一个 HTML 生成器，用于显示 Active Model 抛出的错误。默认为：

Proc.new do |html_tag, instance|
  %Q(<div class="field_with_errors">#{html_tag}</div>).html_safe
end
config.action_view.default_form_builder 告诉 Rails 默认使用哪个表单构造器。默认为 ActionView::Helpers::FormBuilder。如果想在初始化之后加载表单构造器类，把值设为一个字符串。

config.action_view.logger 接受符合 Log4r 接口的日志记录器，或者默认的 Ruby Logger 类，用于记录 Action View 的信息。设为 nil 时禁用日志。

config.action_view.erb_trim_mode 让 ERB 使用修剪模式。默认为 '-'，使用 <%= -%> 或 <%= =%> 时裁掉尾部的空白和换行符。详情参见 Erubis 的文档。

config.action_view.embed_authenticity_token_in_remote_forms 设定具有 remote: true 选项的表单中 authenticity_token 的默认行为。默认设为 false，即远程表单不包含 authenticity_token，对表单做片段缓存时可以这么设。远程表单从 meta 标签中获取真伪令牌，因此除非要支持没有 JavaScript 的浏览器，否则不应该内嵌在表单中。如果想支持没有 JavaScript 的浏览器，可以在表单选项中设定 authenticity_token: true，或者把这个配置设为 true。

config.action_view.prefix_partial_path_with_controller_namespace 设定渲染嵌套在命名空间中的控制器时是否在子目录中寻找局部视图。例如，Admin::ArticlesController 渲染这个模板：

<%= render @article %>
默认设置是 true，使用局部视图 /admin/articles/_article.erb。设为 false 时，渲染 /articles/_article.erb——这与渲染没有放入命名空间中的控制器一样，例如 ArticlesController。

config.action_view.raise_on_missing_translations 设定缺少翻译时是否抛出错误。

config.action_view.automatically_disable_submit_tag 设定点击提交按钮（submit_tag）时是否自动将其禁用。默认为 true。

config.action_view.debug_missing_translation 设定是否把缺少的翻译键放在 <span> 标签中。默认为 true。


配置 Action Mailer

config.action_mailer 有一些配置选项：

config.action_mailer.logger 接受符合 Log4r 接口的日志记录器，或者默认的 Ruby Logger 类，用于记录 Action Mailer 的信息。设为 nil 时禁用日志。

config.action_mailer.smtp_settings 用于详细配置 :smtp 发送方法。值是一个选项散列，包含下述选项：

:address：设定远程邮件服务器的地址。默认为 localhost。

:port：如果邮件服务器不在 25 端口上（很少发生），可以修改这个选项。

:domain：如果需要指定 HELO 域名，通过这个选项设定。

:user_name：如果邮件服务器需要验证身份，通过这个选项设定用户名。

:password：如果邮件服务器需要验证身份，通过这个选项设定密码。

:authentication：如果邮件服务器需要验证身份，要通过这个选项设定验证类型。这个选项的值是一个符号，可以是 :plain、:login 或 :cram_md5。

config.action_mailer.sendmail_settings 用于详细配置 sendmail 发送方法。值是一个选项散列，包含下述选项：

:location：sendmail 可执行文件的位置。默认为 /usr/sbin/sendmail。

:arguments：命令行参数。默认为 -i。

config.action_mailer.raise_delivery_errors 指定无法发送电子邮件时是否抛出错误。默认为 true。

config.action_mailer.delivery_method 设定发送方法，默认为 :smtp。详情参见 16.6 节。

config.action_mailer.perform_deliveries 指定是否真的发送邮件，默认为 true。测试时建议设为 false。

config.action_mailer.default_options 配置 Action Mailer 的默认值。用于为每封邮件设定 from 或 reply_to 等选项。设定的默认值为：

mime_version:  "1.0",
charset:       "UTF-8",
content_type: "text/plain",
parts_order:  ["text/plain", "text/enriched", "text/html"]
若想设定额外的选项，使用一个散列：

config.action_mailer.default_options = {
  from: "noreply@example.com"
}
config.action_mailer.observers 注册观测器（observer），发送邮件时收到通知。

config.action_mailer.observers = ["MailObserver"]
config.action_mailer.interceptors 注册侦听器（interceptor），在发送邮件前调用。

config.action_mailer.interceptors = ["MailInterceptor"]
config.action_mailer.preview_path 指定邮件程序预览的位置。

config.action_mailer.preview_path = "#{Rails.root}/lib/mailer_previews"
config.action_mailer.show_previews 启用或禁用邮件程序预览。开发环境默认为 true。

config.action_mailer.show_previews = false
config.action_mailer.deliver_later_queue_name 设定邮件程序的队列名称。默认为 mailers。

config.action_mailer.perform_caching 指定是否片段缓存邮件模板。在所有环境中默认为 false。

配置 Active Support

Active Support 有一些配置选项：

config.active_support.bare 指定在启动 Rails 时是否加载 active_support/all。默认为 nil，即加载 active_support/all。

config.active_support.test_order 设定执行测试用例的顺序。可用的值是 :random 和 :sorted。对新生成的应用来说，在 config/environments/test.rb 文件中设为 :random。如果应用没指定测试顺序，在 Rails 5.0 之前默认为 :sorted，之后默认为 :random。

config.active_support.escape_html_entities_in_json 指定在 JSON 序列化中是否转义 HTML 实体。默认为 true。

config.active_support.use_standard_json_time_format 指定是否把日期序列化成 ISO 8601 格式。默认为 true。

config.active_support.time_precision 设定 JSON 编码的时间值的精度。默认为 3。

ActiveSupport.halt_callback_chains_on_return_false 指定是否可以通过在前置回调中返回 false 停止 Active Record 和 Active Model 回调链。设为 false 时，只能通过 throw(:abort) 停止回调链。设为 true 时，可以通过返回 false 停止回调链（Rails 5 之前版本的行为），但是会发出弃用提醒。在弃用期内默认为 true。新的 Rails 5 应用会生成一个名为 callback_terminator.rb 的初始化文件，把值设为 false。执行 rails app:update 命令时不会添加这个文件，因此把旧应用升级到 Rails 5 后依然可以通过返回 false 停止回调链，不过会显示弃用提醒，提示用户升级代码。

ActiveSupport::Logger.silencer 设为 false 时静默块的日志。默认为 true。

ActiveSupport::Cache::Store.logger 指定缓存存储操作使用的日志记录器。

ActiveSupport::Deprecation.behavior 的作用与 config.active_support.deprecation 相同，用于配置 Rails 弃用提醒的行为。

ActiveSupport::Deprecation.silence 接受一个块，块里的所有弃用提醒都静默。

ActiveSupport::Deprecation.silenced 设定是否显示弃用提醒。

配置 Active Job

config.active_job 提供了下述配置选项：

config.active_job.queue_adapter 设定队列后端的适配器。默认的适配器是 :async。最新的内置适配器参见 ActiveJob::QueueAdapters 的 API 文档。

# 要把适配器的 gem 写入 Gemfile
# 请参照适配器的具体安装和部署说明
config.active_job.queue_adapter = :sidekiq
config.active_job.default_queue_name 用于修改默认的队列名称。默认为 "default"。

config.active_job.default_queue_name = :medium_priority
config.active_job.queue_name_prefix 用于为所有作业设定队列名称的前缀（可选）。默认为空，不使用前缀。

做下述配置后，在生产环境中运行时把指定作业放入 production_high_priority 队列中：

config.active_job.queue_name_prefix = Rails.env
class GuestsCleanupJob < ActiveJob::Base
  queue_as :high_priority
  #....
end
config.active_job.queue_name_delimiter 的默认值是 '_'。如果设定了 queue_name_prefix，使用 queue_name_delimiter 连接前缀和队列名。

下述配置把指定作业放入 video_server.low_priority 队列中：

# 设定了前缀才会使用分隔符
config.active_job.queue_name_prefix = 'video_server'
config.active_job.queue_name_delimiter = '.'
class EncoderJob < ActiveJob::Base
  queue_as :low_priority
  #....
end
config.active_job.logger 接受符合 Log4r 接口的日志记录器，或者默认的 Ruby Logger 类，用于记录 Action Job 的信息。在 Active Job 类或实例上调用 logger 方法可以获取日志记录器。设为 nil 时禁用日志。


配置 Action Cable

config.action_cable.url 的值是一个 URL 字符串，指定 Action Cable 服务器的地址。如果 Action Cable 服务器与主应用的服务器不同，可以使用这个选项。

config.action_cable.mount_path 的值是一个字符串，指定把 Action Cable 挂载在哪里，作为主服务器进程的一部分。默认为 /cable。可以设为 nil，不把 Action Cable 挂载为常规 Rails 服务器的一部分。


配置数据库

几乎所有 Rails 应用都要与数据库交互。可以通过环境变量 ENV['DATABASE_URL'] 或 config/database.yml 配置文件中的信息连接数据库。

在 config/database.yml 文件中可以指定访问数据库所需的全部信息：

development:
  adapter: postgresql
  database: blog_development
  pool: 5
此时使用 postgresql 适配器连接名为 blog_development 的数据库。这些信息也可以存储在一个 URL 中，然后通过环境变量提供，如下所示：

> puts ENV['DATABASE_URL']
postgresql://localhost/blog_development?pool=5
config/database.yml 文件分成三部分，分别对应 Rails 默认支持的三个环境：

development 环境在开发（本地）电脑中使用，手动与应用交互。

test 环境用于运行自动化测试。

production 环境在把应用部署到线上时使用。

如果愿意，可以在 config/database.yml 文件中指定连接 URL：

development:
  url: postgresql://localhost/blog_development?pool=5
config/database.yml 文件中可以包含 ERB 标签 <%= %>。这个标签中的内容作为 Ruby 代码执行。可以使用这个标签从环境变量中获取数据，或者执行计算，生成所需的连接信息。

提示
无需自己动手更新数据库配置。如果查看应用生成器的选项，你会发现其中一个名为 --database。通过这个选项可以从最常使用的关系数据库中选择一个。甚至还可以重复运行这个生成器：cd .. && rails new blog --database=mysql。同意重写 config/database.yml 文件后，应用的配置会针对 MySQL 更新。常见的数据库连接示例参见下文。


21.3.15 连接配置的优先级

因为有两种配置连接的方式（使用 config/database.yml 文件或者一个环境变量），所以要明白二者之间的关系。

如果 config/database.yml 文件为空，而 ENV['DATABASE_URL'] 有值，那么 Rails 使用环境变量连接数据库：

$ cat config/database.yml

$ echo $DATABASE_URL
postgresql://localhost/my_database
如果在 config/database.yml 文件中做了配置，而 ENV['DATABASE_URL'] 没有值，那么 Rails 使用这个文件中的信息连接数据库：

$ cat config/database.yml
development:
  adapter: postgresql
  database: my_database
  host: localhost

$ echo $DATABASE_URL
如果 config/database.yml 文件中做了配置，而且 ENV['DATABASE_URL'] 有值，Rails 会把二者合并到一起。为了更好地理解，必须看些示例。

如果连接信息有重复，环境变量中的信息优先级高：

$ cat config/database.yml
development:
  adapter: sqlite3
  database: NOT_my_database
  host: localhost

$ echo $DATABASE_URL
postgresql://localhost/my_database

$ bin/rails runner 'puts ActiveRecord::Base.configurations'
{"development"=>{"adapter"=>"postgresql", "host"=>"localhost", "database"=>"my_database"}}
可以看出，适配器、主机和数据库与 ENV['DATABASE_URL'] 中的信息匹配。

如果信息无重复，都是唯一的，遇到冲突时还是环境变量中的信息优先级高：

$ cat config/database.yml
development:
  adapter: sqlite3
  pool: 5

$ echo $DATABASE_URL
postgresql://localhost/my_database

$ bin/rails runner 'puts ActiveRecord::Base.configurations'
{"development"=>{"adapter"=>"postgresql", "host"=>"localhost", "database"=>"my_database", "pool"=>5}}
ENV['DATABASE_URL'] 没有提供连接池数量，因此从文件中获取。而两处都有 adapter，因此 ENV['DATABASE_URL'] 中的连接信息胜出。

如果不想使用 ENV['DATABASE_URL'] 中的连接信息，唯一的方法是使用 "url" 子键指定一个 URL：

$ cat config/database.yml
development:
  url: sqlite3:NOT_my_database

$ echo $DATABASE_URL
postgresql://localhost/my_database

$ bin/rails runner 'puts ActiveRecord::Base.configurations'
{"development"=>{"adapter"=>"sqlite3", "database"=>"NOT_my_database"}}
这里，ENV['DATABASE_URL'] 中的连接信息被忽略了。注意，适配器和数据库名称不同了。

因为在 config/database.yml 文件中可以内嵌 ERB，所以最好明确表明使用 ENV['DATABASE_URL'] 连接数据库。这在生产环境中特别有用，因为不应该把机密信息（如数据库密码）提交到源码控制系统中（如 Git）。

$ cat config/database.yml
production:
  url: <%= ENV['DATABASE_URL'] %>
现在的行为很明确，只使用 <%= ENV['DATABASE_URL'] %> 中的连接信息。


非侵入式 JavaScript
Rails 使用一种叫做“非侵入式 JavaScript”（Unobtrusive JavaScript）的技术把 JavaScript 依附到 DOM 上。非侵入式 JavaScript 是前端开发社区推荐的做法，但有些教程可能会使用其他方式。

下面是编写 JavaScript 最简单的方式，你可能见过，这叫做“行间 JavaScript”：

<a href="#" onclick="this.style.backgroundColor='#990000'">Paint it red</a>
点击链接后，链接的背景会变成红色。这种用法的问题是，如果点击链接后想执行大量 JavaScript 代码怎么办？

<a href="#" onclick="this.style.backgroundColor='#009900';this.style.color='#FFFFFF';">Paint it green</a>
太别扭了，不是吗？我们可以把处理点击的代码定义成一个函数，用 CoffeeScript 编写如下：

@paintIt = (element, backgroundColor, textColor) ->
  element.style.backgroundColor = backgroundColor
  if textColor?
    element.style.color = textColor
然后在页面中这么写：

<a href="#" onclick="paintIt(this, '#990000')">Paint it red</a>
这种方法好点儿，但是如果很多链接需要同样的效果该怎么办呢？

<a href="#" onclick="paintIt(this, '#990000')">Paint it red</a>
<a href="#" onclick="paintIt(this, '#009900', '#FFFFFF')">Paint it green</a>
<a href="#" onclick="paintIt(this, '#000099', '#FFFFFF')">Paint it blue</a>
这样非常不符合 DRY 原则。为了解决这个问题，我们可以使用“事件”。在链接上添加一个 data-* 属性，然后把处理程序绑定到拥有这个属性的点击事件上：

@paintIt = (element, backgroundColor, textColor) ->
  element.style.backgroundColor = backgroundColor
  if textColor?
    element.style.color = textColor

$ ->
  $("a[data-background-color]").click (e) ->
    e.preventDefault()

    backgroundColor = $(this).data("background-color")
    textColor = $(this).data("text-color")
    paintIt(this, backgroundColor, textColor)
<a href="#" data-background-color="#990000">Paint it red</a>
<a href="#" data-background-color="#009900" data-text-color="#FFFFFF">Paint it green</a>
<a href="#" data-background-color="#000099" data-text-color="#FFFFFF">Paint it blue</a>
我们把这种方法称为“非侵入式 JavaScript”，因为 JavaScript 代码不再和 HTML 混合在一起。这样做正确分离了关注点，易于修改功能。我们可以轻易地把这种效果应用到其他链接上，只要添加相应的 data 属性即可。我们可以简化并拼接全部 JavaScript，然后在各个页面加载一个 JavaScript 文件，这样只在第一次请求时需要加载，后续请求都会直接从缓存中读取。“非侵入式 JavaScript”带来的好处太多了。

Rails 团队极力推荐使用这种方式编写 CoffeeScript（以及 JavaScript），而且你会发现很多代码库都采用了这种方式。

26掌握以下几小节的内容对理解常量自动加载和重新加载有所帮助。
module XML
  class SAXParser
    # (1)
  end
end
类和模块的嵌套由内向外展开。嵌套可以通过 Module.nesting 方法审查。例如，在上述示例中，(1) 处的嵌套是

[XML::SAXParser, XML]


注意，组成嵌套的是类和模块“对象”，而不是访问它们的常量，与它们的名称也没有关系。

例如，对下面的定义来说

class XML::SAXParser
  # (2)
end
虽然作用跟前一个示例类似，但是 (2) 处的嵌套是

[XML::SAXParser]
不含“XML”。

从这个示例可以看出，嵌套中的类或模块的名称与所在的命名空间没有必然联系。

事实上，二者毫无关系。比如说：

module X
  module Y
  end
end

module A
  module B
  end
end

module X::Y
  module A::B
    # (3)
  end
end
(3) 处的嵌套包含两个模块对象：

[A::B, X::Y]
可以看出，嵌套的最后不是“A”，甚至不含“A”，但是包含 X::Y，而且它与 A::B 无关。

嵌套是解释器维护的一个内部堆栈，根据下述规则修改：

执行 class 关键字后面的定义体时，类对象入栈；执行完毕后出栈。

执行 module 关键字后面的定义体时，模块对象入栈；执行完毕后出栈。

执行 class << object 打开的单例类时，类对象入栈；执行完毕后出栈。

调用 instance_eval 时如果传入字符串参数，接收者的单例类入栈求值的代码所在的嵌套层次。调用 class_eval 或 module_eval 时如果传入字符串参数，接收者入栈求值的代码所在的嵌套层次.

顶层代码中由 Kernel#load 解释嵌套是空的，除非调用 load 时把第二个参数设为真值；如果是这样，Ruby 会创建一个匿名模块，将其入栈。

注意，块不会修改嵌套堆栈。尤其要注意的是，传给 Class.new 和 Module.new 的块不会导致定义的类或模块入栈嵌套堆栈。由此可见，以不同的方式定义类和模块，达到的效果是有区别的

定义类和模块是为常量赋值

假设下面的代码片段是定义一个类（而不是打开类）：

class C
end
Ruby 在 Object 中创建一个变量 C，并将一个类对象存储在 C 常量中。这个类实例的名称是“C”，一个字符串，跟常量名一样。

如下的代码：

class Project < ApplicationRecord
end
这段代码执行的操作等效于下述常量赋值：

Project = Class.new(ApplicationRecord)
而且有个副作用——设定类的名称：

Project.name # => "Project"
这得益于常量赋值的一条特殊规则：如果被赋值的对象是匿名类或模块，Ruby 会把对象的名称设为常量的名称。

提示
自此之后常量和实例发生的事情无关紧要。例如，可以把常量删除，类对象可以赋值给其他常量，或者不再存储于常量中，等等。名称一旦设定就不会再变。
类似地，模块使用 module 关键字创建，如下所示：

module Admin
end
这段代码执行的操作等效于下述常量赋值：

Admin = Module.new
而且有个副作用——设定模块的名称：

Admin.name # => "Admin"
提醒
传给 Class.new 或 Module.new 的块与 class 或 module 关键字的定义体不在完全相同的上下文中执行。但是两种方式得到的结果都是为常量赋值。
因此，当人们说“String 类”的时候，真正指的是 Object 常量中存储的一个类对象，它存储着常量“String”中存储的一个类对象。而 String 是一个普通的 Ruby 常量，与常量有关的一切，例如解析算法，在 String 常量上都适用。
同样地，在下述控制器中

class PostsController < ApplicationController
  def index
    @posts = Post.all
  end
end
Post 不是调用类的句法，而是一个常规的 Ruby 常量。如果一切正常，这个常量的求值结果是一个能响应 all 方法的对象。
因此，我们讨论的话题才是“常量”自动加载。Rails 提供了自动加载常量的功能。

我们来看看下述模块定义：

module Colors
  RED = '0xff0000'
end
首先，处理 module 关键字时，解释器会在 Object 常量存储的类对象的常量表中新建一个条目。这个条目把“Colors”与一个新建的模块对象关联起来。而且，解释器把那个新建的模块对象的名称设为字符串“Colors”。

随后，解释模块的定义体时，会在 Colors 常量中存储的模块对象的常量表中新建一个条目。那个条目把“RED”映射到字符串“0xff0000”上。

注意，Colors::RED 与其他类或模块对象中的 RED 常量完全没有关系。如果存在这样一个常量，它在相应的常量表中，是不同的条目。

在前述各段中，尤其要注意类和模块对象、常量名称，以及常量表中与之关联的值对象之间的区别。

解析算法

26.2.4.1 相对常量的解析算法
在代码中的特定位置，假如使用 cref 表示嵌套中的第一个元素，如果没有嵌套，则表示 Object。

简单来说，相对常量（relative constant）引用的解析算法如下：

如果嵌套不为空，在嵌套中按元素顺序查找常量。元素的祖先忽略不计。

如果未找到，算法向上，进入 cref 的祖先链。

如果未找到，而且 cref 是个模块，在 Object 中查找常量。

如果未找到，在 cref 上调用 const_missing 方法。这个方法的默认行为是抛出 NameError 异常，不过可以覆盖。

Rails 的自动加载机制没有仿照这个算法，查找的起点是要自动加载的常量名称，即 cref。详情参见 26.6.1 节。
限定常量的解析算法
限定常量（qualified constant）指下面这种：

Billing::Invoice
Billing::Invoice 由两个常量组成，其中 Billing 是相对常量，使用前一节所属的算法解析。

提示
在开头加上两个冒号可以把第一部分的相对常量变成绝对常量，例如 ::Billing::Invoice。此时，Billing 作为顶层常量查找。

#自动加载可用性
只要环境允许，Rails 始终会自动加载。例如，runner 命令会自动加载：

$ bin/rails runner 'p User.column_names'
["id", "email", "created_at", "updated_at"]
控制台会自动加载，测试组件会自动加载，当然，应用也会自动加载。

默认情况下，在生产环境中，Rails 启动时会及早加载应用文件，因此开发环境中的多数自动加载行为不会发生。但是在及早加载的过程中仍然可能会触发自动加载。

例如：class BeachHouse < House
end
如果及早加载 app/models/beach_house.rb 文件之后，House 尚不可知，Rails 会自动加载它


#autoload_paths
或许你已经知道，使用 require 引入相对文件名时，例如

require 'erb'
Ruby 在 $LOAD_PATH 中列出的目录里寻找文件。即，Ruby 迭代那些目录，检查其中有没有名为“erb.rb”“erb.so”“erb.o”或“erb.dll”的文件。如果在某个目录中找到了，解释器加载那个文件，搜索结束。否则，继续在后面的目录中寻找。如果最后没有找到，抛出 LoadError 异常。

后面会详述常量自动加载机制，不过整体思路是，遇到未知的常量时，如 Post，假如 app/models 目录中存在 post.rb 文件，Rails 会找到它，执行它，从而定义 Post 常量。

好吧，其实 Rails 会在一系列目录中查找 post.rb，有点类似于 $LOAD_PATH。那一系列目录叫做 autoload_paths，默认包含：

应用和启动时存在的引擎的 app 目录中的全部子目录。例如，app/controllers。这些子目录不一定是默认的，可以是任何自定义的目录，如 app/workers。app 目录中的全部子目录都自动纳入 autoload_paths。

应用和引擎中名为 app/*/concerns 的二级目录。

test/mailers/previews 目录。

此外，这些目录可以使用 config.autoload_paths 配置。例如，以前 lib 在这一系列目录中，但是现在不在了。应用可以在 config/application.rb 文件中添加下述配置，将其纳入其中：

config.autoload_paths << "#{Rails.root}/lib"
##在各个环境的配置文件中不能配置 config.autoload_paths。

autoload_paths 的值可以审查。在新创建的应用中，它的值是（经过编辑）：

$ bin/rails r 'puts ActiveSupport::Dependencies.autoload_paths'
.../app/assets
.../app/controllers
.../app/helpers
.../app/mailers
.../app/models
.../app/controllers/concerns
.../app/models/concerns
.../test/mailers/previews
提示
autoload_paths 在初始化过程中计算并缓存。目录结构发生变化时，要重启服务器。


#26自动加载算法
##26.6.1 相对引用

相对常量引用可在多处出现，例如：

class PostsController < ApplicationController
  def index
    @posts = Post.all
  end
end
这里的三个常量都是相对引用。

26.6.1.1 class 和 module 关键字后面的常量
Ruby 程序会查找 class 或 module 关键字后面的常量，因为要知道是定义类或模块，还是再次打开。

如果常量不被认为是缺失的，不会定义常量，也不会触发自动加载。

因此，在上述示例中，解释那个文件时，如果 PostsController 未定义，Rails 不会触发自动加载机制，而是由 Ruby 定义那个控制器。
##26.6.1.2顶层常量
相对地，如果 ApplicationController 是未知的，会被认为是缺失的，Rails 会尝试自动加载。

为了加载 ApplicationController，Rails 会迭代 autoload_paths。首先，检查 app/assets/application_controller.rb 文件是否存在，如果不存在（通常如此），再检查 app/controllers/application_controller.rb 是否存在。

如果那个文件定义了 ApplicationController 常量，那就没事，否则抛出 LoadError 异常：

unable to autoload constant ApplicationController, expected
<full path to application_controller.rb> to define it (LoadError)
提示
Rails 不要求自动加载的常量是类或模块对象。假如在 app/models/max_clients.rb 文件中定义了 MAX_CLIENTS = 100，Rails 也能自动加载 MAX_CLIENTS。


##命名空间
自动加载 ApplicationController 时直接检查 autoload_paths 里的目录，因为它没有嵌套。Post 就不同了，那一行的嵌套是 [PostsController]，此时就会使用涉及命名空间的算法。

对下述代码来说：

module Admin
  class BaseController < ApplicationController
    @@all_roles = Role.all
  end
end
为了自动加载 Role，要分别检查当前或父级命名空间中有没有定义 Role。因此，从概念上讲，要按顺序尝试自动加载下述常量：

Admin::BaseController::Role
Admin::Role
Role
为此，Rails 在 autoload_paths 中分别查找下述文件名：

admin/base_controller/role.rb
admin/role.rb
role.rb
此外还会查找一些其他目录，稍后说明。

提示
不含扩展名的相对文件路径通过 'Constant::Name'.underscore 得到，其中 Constant::Name 是已定义的常量。


## bin/rails r 'puts ActiveSupport::Dependencies.autoload_paths'

#26.7 require_dependency
常量自动加载按需触发，因此使用特定常量的代码可能已经定义了常量，或者触发自动加载。具体情况取决于执行路径，二者之间可能有较大差异。

然而，有时执行到某部分代码时想确保特定常量是已知的。require_dependency 为此提供了一种方式。它使用目前的加载机制加载文件，而且会记录文件中定义的常量，就像是自动加载的一样，而且会按需重新加载。

require_dependency 很少需要使用，不过 26.10.2 节和 26.10.6 节有几个用例。

提醒
与自动加载不同，require_dependency 不期望文件中定义任何特定的常量。但是利用这种行为不好，文件和常量路径应该匹配。
#26.8 常量重新加载
config.cache_classes 设为 false 时，Rails 会重新自动加载常量。

例如，在控制台会话中编辑文件之后，可以使用 reload! 命令重新加载代码：

> reload!
在应用运行的过程中，如果相关的逻辑有变，会重新加载代码。为此，Rails 会监控下述文件：

config/routes.rb

本地化文件

autoload_paths 中的 Ruby 文件

db/schema.rb 和 db/structure.sql

如果这些文件中的内容有变，有个中间件会发现，然后重新加载代码。

自动加载机制会记录自动加载的常量。重新加载机制使用 Module#remove_const 方法把它们从相应的类和模块中删除。这样，运行代码时那些常量就变成未知了，从而按需重新加载文件。

提示
这是一个极端操作，Rails 重新加载的不只是那些有变化的代码，因为类之间的依赖极难处理。相反，Rails 重新加载一切。
#26.9 Module#autoload 不涉其中
Module#autoload 提供的是惰性加载常量方式，深置于 Ruby 的常量查找算法、动态常量 API，等等。这一机制相当简单。

Rails 内部在加载过程中大量采用这种方式，尽量减少工作量。但是，Rails 的常量自动加载机制不是使用 Module#autoload 实现的。

如果基于 Module#autoload 实现，可以遍历应用树，调用 autoload 把文件名和常规的常量名对应起来。

Rails 不采用这种实现方式有几个原因。

例如，Module#autoload 只能使用 require 加载文件，因此无法重新加载。不仅如此，它使用的是 require 关键字，而不是 Kernel#require 方法。

因此，删除文件后，它无法移除声明。如果使用 Module#remove_const 把常量删除了，不会触发 Module#autoload。此外，它不支持限定名称，因此有命名空间的文件要在遍历树时解析，这样才能调用相应的 autoload 方法，但是那些文件中可能有尚未配置的常量引用。

基于 Module#autoload 的实现很棒，但是如你所见，目前还不可能。Rails 的常量自动加载机制使用 Module#const_missing 实现，因此才有本文所述的独特算法。


#26.10 常见问题
26.10.1 嵌套和限定常量

假如有下述代码

module Admin
  class UsersController < ApplicationController
    def index
      @users = User.all
    end
  end
end
和

class Admin::UsersController < ApplicationController
  def index
    @users = User.all
  end
end
为了解析 User，对前者来说，Ruby 会检查 Admin，但是后者不会，因为它不在嵌套中（参见 26.2.1 节和 26.2.4 节）。

可惜，在缺失常量的地方，Rails 自动加载机制不知道嵌套，因此行为与 Ruby 不同。具体而言，在两种情况下，Admin::User 都能自动加载。

尽管严格来说某些情况下 class 和 module 关键字后面的限定常量可以自动加载，但是最好使用相对常量：

module Admin
  class UsersController < ApplicationController
    def index
      @users = User.all
    end
  end
end


#对称加密算法在加密和解密时使用的是同一个秘钥；而非对称加密算法需要两个密钥来进行加密和解密，这两个秘钥是公开密钥（public 
key，简称公钥）和私有密钥（private key，简称私钥）。




#26.10.3 自动加载和 require

通过自动加载机制加载的定义常量的文件一定不能使用 require 引入：

require 'user' # 千万别这么做

class UsersController < ApplicationController
  ...
end
如果这么做，在开发环境中会导致两个问题：

如果在执行 require 之前自动加载了 User，app/models/user.rb 会再次运行，因为 load 不会更新 $LOADED_FEATURES。

如果 require 先执行了，Rails 不会把 User 标记为自动加载的常量，因此 app/models/user.rb 文件中的改动不会重新加载。

我们应该始终遵守规则，使用常量自动加载机制，一定不能混用自动加载和 require。底线是，如果一定要加载特定的文件，使用 require_dependency，这样能正确利用常量自动加载机制。不过，实际上很少需要这么做。

##当然，在自动加载的文件中使用 require 加载第三方库没问题，Rails 会做区分，不把第三方库里的常量标记为自动加载的。

#26.10.4 自动加载和初始化脚本

假设 config/initializers/set_auth_service.rb 文件中有下述赋值语句：

AUTH_SERVICE = if Rails.env.production?
  RealAuthService
else
  MockedAuthService
end
这么做的目的是根据所在环境为 AUTH_SERVICE 赋予不同的值。在开发环境中，运行这个初始化脚本时，自动加载 MockedAuthService。假如我们发送了几个请求，修改了实现，然后再次运行应用，奇怪的是，改动没有生效。这是为什么呢？

从前文得知，Rails 会删除自动加载的常量，但是 AUTH_SERVICE 存储的还是原来那个类对象。原来那个常量不存在了，但是功能完全不受影响。

下述代码概述了这种情况：

class C
  def quack
    'quack!'
  end
end

X = C
Object.instance_eval { remove_const(:C) }
X.new.quack # => quack!
X.name      # => C
C           # => uninitialized constant C (NameError)
##鉴于此，不建议在应用初始化过程中自动加载常量。

对上述示例来说，我们可以实现一个动态接入点：

# app/models/auth_service.rb
class AuthService
  if Rails.env.production?
    def self.instance
      RealAuthService
    end
  else
    def self.instance
      MockedAuthService
    end
  end
end
然后在应用中使用 AuthService.instance。这样，AuthService 会按需加载，而且能顺利自动加载。

##26.10.5 require_dependency 和初始化脚本

前面说过，require_dependency 加载的文件能顺利自动加载。但是，一般来说不应该在初始化脚本中使用。

有人可能觉得在初始化脚本中调用 require_dependency 能确保提前加载特定的常量，例如用于解决 STI 问题。

问题是，在开发环境中，如果文件系统中有相关的改动，自动加载的常量会被抹除。这样就与使用初始化脚本的初衷背道而驰了。

require_dependency 调用应该写在能自动加载的地方。

#26.10.6 常量未缺失

##26.10.6.1 相对引用
以一个飞行模拟器为例。应用中有个默认的飞行模型：

# app/models/flight_model.rb
class FlightModel
end
每架飞机都可以将其覆盖，例如：

# app/models/bell_x1/flight_model.rb
module BellX1
  class FlightModel < FlightModel
  end
end

# app/models/bell_x1/aircraft.rb
module BellX1
  class Aircraft
    def initialize
      @flight_model = FlightModel.new
    end
  end
end
初始化脚本想创建一个 BellX1::FlightModel 对象，而且嵌套中有 BellX1，看起来这没什么问题。但是，如果默认飞行模型加载了，但是 Bell-X1 模型没有，解释器能解析顶层的 FlightModel，因此 BellX1::FlightModel 不会触发自动加载机制。

这种代码取决于执行路径。

这种歧义通常可以通过限定常量解决：

module BellX1
  class Plane
    def flight_model
      @flight_model ||= BellX1::FlightModel.new
    end
  end
end
此外，使用 require_dependency 也能解决：

require_dependency 'bell_x1/flight_model'

module BellX1
  class Plane
    def flight_model
      @flight_model ||= FlightModel.new
    end
  end
end


##26.10.6.2 限定引用
对下述代码来说

# app/models/hotel.rb
class Hotel
end

# app/models/image.rb
class Image
end

# app/models/hotel/image.rb
class Hotel
  class Image < Image
  end
end
Hotel::Image 这个表达式有歧义，因为它取决于执行路径。

从前文得知，Ruby 会在 Hotel 及其祖先中查找常量。如果加载了 app/models/image.rb 文件，但是没有加载 app/models/hotel/image.rb，Ruby 在 Hotel 中找不到 Image，而在 Object 中能找到：

$ bin/rails r 'Image; p Hotel::Image' 2>/dev/null
Image # 不是 Hotel::Image！
若想得到 Hotel::Image，要确保 app/models/hotel/image.rb 文件已经加载——或许是使用 require_dependency 加载的。

不过，在这些情况下，解释器会发出提醒：

warning: toplevel constant Image referenced by Hotel::Image
任何限定的类都能发现这种奇怪的常量解析行为：

2.1.5 :001 > String::Array
(irb):1: warning: toplevel constant Array referenced by String::Array
 => Array
提醒
为了发现这种问题，限定命名空间必须是类。Object 不是模块的祖先。


##26.10.7 单例类中的自动加载

假如有下述类定义：

# app/models/hotel/services.rb
module Hotel
  class Services
  end
end

# app/models/hotel/geo_location.rb
module Hotel
  class GeoLocation
    class << self
      Services
    end
  end
end
如果加载 app/models/hotel/geo_location.rb 文件时 Hotel::Services 是已知的，Services 由 Ruby 解析，因为打开 Hotel::GeoLocation 的单例类时，Hotel 在嵌套中。

但是，如果 Hotel::Services 是未知的，Rails 无法自动加载它，应用会抛出 NameError 异常。

###这是因为单例类（匿名的）会触发自动加载，从前文得知，在这种边缘情况下，Rails 只检查顶层命名空间。

这个问题的简单解决方案是使用限定常量：

module Hotel
  class GeoLocation
    class << self
      Hotel::Services
    end
  end
end


##26.10.8 BasicObject 中的自动加载

BasicObject 的直接子代的祖先中没有 Object，因此无法解析顶层常量：

class C < BasicObject
  String # NameError: uninitialized constant C::String
end
如果涉及自动加载，情况稍微复杂一些。对下述代码来说

class C < BasicObject
  def user
    User # 错误
  end
end
因为 Rails 会检查顶层命名空间，所以第一次调用 user 方法时，User 能自动加载。但是，如果 User 是已知的，尤其是第二次调用 user 方法时，情况就不同了：

c = C.new
c.user # 奇怪的是能正常运行，返回 User
c.user # NameError: uninitialized constant C::User
因为此时发现父级命名空间中已经有那个常量了（参见 26.6.2 节）。

在纯 Ruby 代码中，在 BasicObject 的直接子代的定义体中应该始终使用绝对常量路径：

class C < BasicObject
  ::String # 正确

  def user
    ::User # 正确
  end
end

#第 27 章 Rails 缓存概览

本文简述如何使用缓存提升 Rails 应用的速度。

缓存是指存储请求-响应循环中生成的内容，在类似请求的响应中复用。

通常，缓存是提升应用性能最有效的方式。通过缓存，在单个服务器中使用单个数据库的网站可以承受数千个用户并发访问。

Rails 自带了一些缓存功能。本文说明它们的适用范围和作用。掌握这些技术之后，你的 Rails 应用能承受大量访问，而不必花大量时间生成响应，或者支付高昂的服务器账单。

读完本文后，您将学到：

片段缓存和俄罗斯套娃缓存；

如何管理缓存依赖；

不同的缓存存储器；

对条件 GET 请求的支持
##27.1基本缓存
本节简介三种缓存技术：页面缓存（page caching）、动作缓存（action caching）和片段缓存（fragment caching）。Rails 默认提供了片段缓存。如果想使用页面缓存或动作缓存，要把 actionpack-page_caching 或 actionpack-action_caching 添加到 Gemfile 中。
##27.1.1 页面缓存

页面缓存时 Rails 提供的一种缓存机制，让 Web 服务器（如 Apache 和 NGINX）直接伺服生成的页面，而不经由 Rails 栈处理。虽然这种缓存的速度超快，但是不适用于所有情况（例如需要验证身份的页面）。此外，因为 Web 服务器直接从文件系统中伺服文件，所以你要自行实现缓存失效机制。

提示
Rails 4 删除了页面缓存。参见 actionpack-page_caching gem。
##27.1.2 动作缓存

有前置过滤器的动作不能使用页面缓存，例如需要验证身份的页面。此时，应该使用动作缓存。动作缓存的工作原理与页面缓存类似，不过入站请求会经过 Rails 栈处理，以便运行前置过滤器，然后再伺服缓存。这样，可以做身份验证和其他限制，同时还能从缓存的副本中伺服结果。

提示
Rails 4 删除了动作缓存。参见 actionpack-action_caching gem。最新推荐的做法参见 DHH 写的“How key-based cache expiration works”一文。
https://signalvnoise.com/posts/3113-how-key-based-cache-expiration-works
##片段缓存

动态 Web 应用一般使用不同的组件构建页面，不是所有组件都能使用同一种缓存机制。如果页面的不同部分需要使用不同的缓存机制，在不同的条件下失效，可以使用片段缓存。

片段缓存把视图逻辑的一部分放在 cache 块中，下次请求使用缓存存储器中的副本伺服。

例如，如果想缓存页面中的各个商品，可以使用下述代码：

<% @products.each do |product| %>
  <% cache product do %>
    <%= render product %>
  <% end %>
<% end %>
首次访问这个页面时，Rails 会创建一个具有唯一键的缓存条目。缓存键类似下面这种：

views/products/1-201505056193031061005000/bea67108094918eeba42cd4a6e786901
中间的数字是 product_id 加上商品记录的 updated_at 属性中存储的时间戳。Rails 使用时间戳确保不伺服过期的数据。如果 updated_at 的值变了，Rails 会生成一个新键，然后在那个键上写入一个新缓存，旧键上的旧缓存不再使用。这叫基于键的失效方式。

视图片段有变化时（例如视图的 HTML 有变），缓存的片段也失效。缓存键末尾那个字符串是模板树摘要，是基于缓存的视图片段的内容计算的 MD5 哈希值。如果视图片段有变化，MD5 哈希值就变了，因此现有文件失效。

提示
Memcached 等缓存存储器会自动删除旧的缓存文件。
如果想在特定条件下缓存一个片段，可以使用 cache_if 或 cache_unless：

<% cache_if admin?, product do %>
  <%= render product %>
<% end %>