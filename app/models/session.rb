class Session < ApplicationRecord
  #会话过期
  # 注意
  # 永不过期的会话增加了跨站请求伪造（CSRF）、会话劫持和会话固定攻击的风险。
  # cookie 的过期时间可以通过会话 ID 设置。然而，客户端能够修改储存在 Web 浏览器中的 cookie，因此在服务器上使会话过期更安全。下面的例子演示如何使储存在数据库中的会话过期。通过调用 Session.sweep("20 minutes")，可以使闲置超过 20 分钟的会话过期。
  def self.sweep(time = 1.hour)
    if time.is_a?(String)
      time = time.split.inject { |count, unit| count.to_i.send(unit) }
    end
    #攻击者每五分钟维护一次会话，就可以使会话永远保持活动，不至过期。针对这个问题的一个简单解决方案是在会话数据表中添加 created_at 字段，这样就可以找出创建了很长时间的会话并删除它们。可以用下面这行代码代替上面例子中的对应代码：

	delete_all "updated_at < '#{time.ago.to_s(:db)}' OR
	  created_at < '#{2.days.ago.to_s(:db)}'"
    # delete_all "updated_at < '#{time.ago.to_s(:db)}'"
  end
end