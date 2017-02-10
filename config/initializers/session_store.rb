# Be sure to restart your server when you modify this file.

Rails.application.config.session_store :cookie_store, key: '_haitaoshop_session'
#config/initializers/session_store.rb  如果想使用其他的会话存储机制，可以在 config/initializers/session_store.rb 文件中设
#Rails 为 CookieStore 提供了一个密令，用来签署会话数据。这个密令可以在 config/secrets.yml 文件中修改：
#使用 CookieStore 时，如果修改了密令，之前所有的会话都会失效。
