class Session < ApplicationRecord
  #会话过期   session save in db can use activerecord-session_store
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

  #跨站请求伪造（CSRF）
# 跨站请求伪造的工作原理是，通过在页面中包含恶意代码或链接，访问已验证用户才能访问的 Web 应用。如果该 Web 应用的会话未超时，攻击者就能执行未经授权的操作。
# csrf
# 在 19.2 节中，我们了解到大多数 Rails 应用都使用基于 cookie 的会话。它们或者把会话 ID 储存在 cookie 中并在服务器端储存会话散列，或者把整个会话散列储存在客户端。不管是哪种情况，只要浏览器能够找到某个域名对应的 cookie，就会自动在发送请求时包含该 cookie。有争议的是，即便请求来源于另一个域名上的网站，浏览器在发送请求时也会包含客户端的 cookie。让我们来看个例子：
# Bob 在访问留言板时浏览了一篇黑客发布的帖子，其中有一个精心设计的 HTML 图像元素。这个元素实际指向的是 Bob 的项目管理应用中的某个操作，而不是真正的图像文件：<img src="http://www.webapp.com/project/1/destroy">。
# Bob 在 www.webapp.com 上的会话仍然是活动的，因为几分钟前他访问这个应用后没有退出。
# 当 Bob 浏览这篇帖子时，浏览器发现了这个图像标签，于是尝试从 www.webapp.com 中加载图像。如前文所述，浏览器在发送请求时包含 cookie，其中就有有效的会话 ID。
# www.webapp.com 上的 Web 应用会验证对应会话散列中的用户信息，并删除 ID 为 1 的项目，然后返回结果页面。由于返回的并非浏览器所期待的结果，图像无法显示。
# Bob 当时并未发觉受到了攻击，但几天后，他发现 ID 为 1 的项目不见了。
# 有一点需要特别注意，像上面这样精心设计的图像或链接，并不一定要出现在 Web 应用所在的域名上，而是可以出现在任何地方，例如论坛、博客帖子，甚至电子邮件中。

# CSRF 对策
# 注意
# 首先根据 W3C 的要求，应该适当地使用 GET 和 POST HTTP 方法。其次，在非 GET 请求中使用安全令牌（security token）可以防止应用受到 CSRF 攻击。


#POST 请求也可以自动发送。在下面的例子中，链接 www.harmless.com 在浏览器状态栏中显示为目标地址，实际上却动态新建了一个发送 POST 请求的表单：

# <a href="http://www.harmless.com/" onclick="
#   var f = document.createElement('form');
#   f.style.display = 'none';
#   this.parentNode.appendChild(f);
#   f.method = 'POST';
#   f.action = 'http://www.example.com/account/destroy';
#   f.submit();
#   return false;">To the harmless survey</a>
# 攻击者还可以把代码放在图片的 onmouseover 事件句柄中：

# <img src="http://www.harmless.com/img" width="400" height="400" onmouseover="..." />
# CSRF 还有很多可能的攻击方式，例如使用 <script> 标签向返回 JSONP 或 JavaScript 的 URL 地址发起跨站请求。对跨站请求的响应，返回的如果是攻击者可以设法运行的可执行代码，就有可能导致敏感数据泄露。为了避免发生这种情况，必须禁用跨站 <script> 标签。不过 Ajax 请求是遵循同源原则的（只有在同一个网站中才能初始化 XmlHttpRequest），因此在响应 Ajax 请求时返回 JavaScript 是安全的，不必担心跨站请求问题
end