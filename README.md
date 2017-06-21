# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

在heroku上的程序没有进行预编译。



首先查看设置：

# config/environments/production.rb
...
config.assets.compile = true
...


看这里正确与否，然后本地运行：

bundle exec rake assets:precompile


然后提交并再次部署到heroku上