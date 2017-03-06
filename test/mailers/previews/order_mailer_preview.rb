# Preview all emails at http://localhost:3000/rails/mailers/order_mailer
class OrderMailerPreview < ActionMailer::Preview
  #预览电子邮件Action Mailer 提供了预览功能，通过一个特殊的 URL 访问。对上述示例来说，UserMailer 的预览类是 UserMailerPreview，存储在 test/mailers/previews/user_mailer_preview.rb 文件中。如果想预览 welcome_email，实现一个同名方法，在里面调用 UserMailer.welcome_email：
  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/received
  #默认情况下，预览类存放在 test/mailers/previews 文件夹中。这个位置可以使用 preview_path 选项配置。假如想把它改成 lib/mailer_previews，可以在 config/application.rb 文件中这样配置：
  # config.action_mailer.preview_path = "#{Rails.root}/lib/mailer_previews"
  def received
    OrderMailer.received(Order.first)
  end

  # Preview this email at http://localhost:3000/rails/mailers/order_mailer/shipped
  def shipped
    OrderMailer.shipped(Order.first)
  end

end
