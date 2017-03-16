source 'https://rubygems.org'


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0', '>= 5.0.0.1'
# # Use sqlite3 as the database for Active Record

# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
#Turbolinks 为页面中所有的 <a> 元素添加一个点击事件处理程序。如果浏览器支持 PushState，Turbolinks 会发起 Ajax 请求，解析响应，然后使用响应主体替换原始页面的整个 <body> 元素。最后，使用 PushState 技术更改页面的 URL，让新页面可刷新，并且有个精美的 URL。
# 要想使用 Turbolinks，只需将其加入 Gemfile，然后在 app/assets/javascripts/application.js 中加入 //= require turbolinks。
# 如果某个链接不想使用 Turbolinks，可以在链接中添加 data-turbolinks="false" 属性：
# <a href="..." data-turbolinks="false">No turbolinks here</a>.
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'

# Use ActiveModel has_secure_password
 gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
end

gem 'will_paginate','>= 3.0.pre'


gem 'capistrano-rails',group: :development
gem 'capistrano-rvm',group: :development
gem 'capistrano-bundler',group: :development
gem 'capistrano-passenger',group: :development

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

# group :production do
# 	gem 'mysql2'#, '~>0.4.0'
# end
#!!Heroku works only with PostgreSQL
#搭建 Heroku 部署环境 Run `bundle install` to install missing gems.
gem 'sqlite3', group: [:development, :test]
gem 'pg', group: [:production]
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0', group: [:production]
# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

gem 'activemerchant','~> 1.58'
gem 'haml','~> 4.0'
gem 'kaminari','~> 0.16'