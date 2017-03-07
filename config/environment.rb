# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

# Rails.logger = Logger.new(STDOUT)
# config.log_level = :warn # In any environment initializer, or
# Rails.logger.level = 0 # at any time
#默认情况下，日志文件都保存在 Rails.root/log/ 文件夹中，日志文件名为 environment_name.log。
Rails.application.configure do
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_options = {from: 'ybinbin@outlook.com'}
  #add email
  config.action_mailer.delivery_method = :smtp
  #Alternatives to :smtp include :sendmail and :test
  config.action_mailer.smtp_settings = {
    address: "smtp.163.com",
    port: 25,#587
    #domain: ".163.com",
    authentication: "plain",
    user_name: "18036096795",
    password: "hello123",
    enable_starttls_auto: true ,
    authentication: 'plain'
  }

end