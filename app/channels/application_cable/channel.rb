module ApplicationCable
  #和常规 MVC 中的控制器类似，频道用于封装逻辑工作单元。默认情况下，Rails 会把 ApplicationCable::Channel 类作为频道的父类，用于封装频道之间共享的逻辑。
  class Channel < ActionCable::Channel::Base
  end
end
