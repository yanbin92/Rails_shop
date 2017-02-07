# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

Rails.application.configure do
 #add email
  config.action_mailer.delivery_method = :smtp
  #Alternatives to :smtp include :sendmail and :test
  config.action_mailer.smtp_settings = {
    address: "smtp.163.com",
    port: 587,
    #domain: "",
    authentication: "plain",
    user_name: "3271941995@qq.com",
    password: "hello123",
    enable_starttls_auto: true 
  }

end