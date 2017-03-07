class OrderMailer < ApplicationMailer
  #default：一个散列，该邮件程序发出邮件的默认设置。上例中，我们把 :from 邮件头设为一个值，这个类中的所有动作都会使用这个值
  default from: 'Haitao shop <18036096795@163.com>'
  # 把邮件发给多个收件人
  # 若想把一封邮件发送给多个收件人，例如通知所有管理员有新用户注册，可以把 :to 键的值设为一组邮件地址。这一组邮件地址可以是一个数组；也可以是一个字符串，使用逗号分隔各个地址。
  # default to: Proc.new { Admin.pluck(:email) }
  # 使用类似的方式还可添加抄送和密送，分别设置 :cc 和 :bcc 键即可

  #下面这三个方法是邮件程序中最重要的方法：
  # headers：设置邮件头，可以指定一个由字段名和值组成的散列，也可以使用 headers[:field_name] = 'value' 形式；
  # attachments：添加邮件的附件，例如，attachments['file-name.jpg'] = File.read('file-name.jpg')；
  # mail：发送邮件，传入的值为散列形式的邮件头，mail 方法负责创建邮件——纯文本或多种格式，这取决于定义了哪种邮件模板
  #

  #在邮件视图中可以像在应用的视图中一样使用 cache 方法缓存视图。

  # <% cache do %>
  #   <%= @company.name %>
  # <% end %>
  #   若想使用这个功能，要在应用中做下述配置：

  # config.action_mailer.perform_caching = true

  #有时可能不想使用布局，而是直接使用字符串渲染邮件内容，为此可以使用 :body 选项。但是别忘了指定 :content_type 选项，否则 Rails 会使用默认值 text/plain。
  def received(order)
    @order = order
    #传入文件名和内容，Action Mailer 和 Mail gem 会自动猜测附件的 MIME 类型，设置编码并创建附件
    attachments['show.jpg'] = File.read(Rails.root.join('app', 'assets', 'images', 'av.jpg'))

    # 如果在发送邮件时想覆盖发送选项（例如，SMTP 凭据），可以在邮件程序的动作中设定 delivery_method_options 选项。
    # delivery_options = { user_name: company.smtp_user,
    #                        password: company.smtp_password,
    #                        address: company.smtp_host }

    #mail：用于发送邮件的方法，我们传入了 :to 和 :subject 邮件头。
    mail to: order.email,subject: "Pragmatic Store Order Confirmation" do|format|
      format.text
    end
    #如果想获得更多灵活性，可以传入一个块，渲染指定的模板，或者不使用模板，渲染行间代码或纯文本：
    # mail(to: @user.email,
    #          subject: 'Welcome to My Awesome Site') do |format|
    #       format.html { render 'another_template' }
    #       format.text { render text: 'Render text' }
    #end

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


  # 也可设置 before_action、after_action 和 around_action。
  # 与控制器中的回调一样，可以指定块，或者方法名的符号形式；
  #   拦截电子邮件
  # 有时，在邮件发送之前需要做些修改。Action Mailer 提供了相应的钩子，可以拦截每封邮件。你可以注册一个拦截器，在交给发送程序之前修改邮件。

  # class SandboxEmailInterceptor
  #   def self.delivering_email(message)
  #     message.to = ['sandbox@example.com']
  #   end
  # end

end
