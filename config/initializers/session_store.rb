# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_haitaoshop_session'
#config/initializers/session_store.rb  如果想使用其他的会话存储机制，
#可以在 config/initializers/session_store.rb 文件中设
#Rails 为 CookieStore 提供了一个密令，用来签署会话数据。这个密令可以在 config/secrets.yml 文件中修改：
#使用 CookieStore 时，如果修改了密令，之前所有的会话都会失效。
#指定使用哪个类存储会话。可用的值有 :cookie_store（默认值）、:mem_cache_store 和 :disabled。最后一个值告诉 Rails 不处理会话。也可以指定自定义的会话存储器：