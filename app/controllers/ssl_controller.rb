class SslController
  force_ssl only: :cheeseburger
  # or
  force_ssl except: :cheeseburger
  #注意，如果你在很多控制器中都使用了 force_ssl，
  #或许你想让整个程序都使用 HTTPS。
  #此时，你可以在环境设置文件中设置 config.force_ssl 选项
end