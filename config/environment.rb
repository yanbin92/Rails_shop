# Load the Rails application.
require_relative 'application'

# Initialize the Rails application.
Rails.application.initialize!

Rails.application.configure do
 #add email
  config.action_mailer.delivery_method = :smtp
  #Alternatives to :smtp include :sendmail and :test
  config.action_mailer.smtp_settings = {
    address: "smtp-mail.outlook.com",
    port: 587,
    #domain: "",
    authentication: "tls",
    user_name: "ybinbin@outlook.com",
    password: "yb112233",
    enable_starttls_auto: true
  }

end