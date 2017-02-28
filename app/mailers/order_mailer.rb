class OrderMailer < ApplicationMailer
  #default：一个散列，该邮件程序发出邮件的默认设置。上例中，我们把 :from 邮件头设为一个值，这个类中的所有动作都会使用这个值
  default from: 'Haitao shop <ybinbin@outlook.com>'
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.received.subject
  #
  def received(order)
    @order = order
    #mail：用于发送邮件的方法，我们传入了 :to 和 :subject 邮件头。
    mail to: order.email,subject: "Pragmatic Store Order Confirmation"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.order_mailer.shipped.subject
  #
  def shipped(order)
    @order = order

    mail to: order.email,subject: "Pragmatic Store Order Shipped"
  end
end
