module ApplicationCable
  #连接是客户端-服务器通信的基础。每当服务器接受一个 WebSocket，就会实例化一个连接对象。所有频道订阅（channel subscription）都是在继承连接对象的基础上创建的。连接本身并不处理身份验证和授权之外的任何应用逻辑。WebSocket 连接的客户端被称为连接用户（connection consumer）。每当用户新打开一个浏览器标签、窗口或设备，对应地都会新建一个用户-连接对（consumer-connection pair）。
  #连接是 ApplicationCable::Connection 类的实例。对连接的授权就是在这个类中完成的，对于能够识别的用户，才会继续建立连接。
  class Connection < ActionCable::Connection::Base
  	# identified_by :current_user

   #  def connect
   #    self.current_user = find_verified_user
   #  end

   #  protected
   #    def find_verified_user
   #      if current_user = User.find_by(id: cookies.signed[:user_id])
   #        current_user
   #      else
   #        reject_unauthorized_connection
   #      end
   #    end
   # 其中 identified_by 用于声明连接标识符，连接标识符稍后将用于查找指定连接。注意，在声明连接标识符的同时，在基于连接创建的频道实例上，会自动创建同名委托（delegate）。
   # 上述例子假设我们已经在应用的其他部分完成了用户身份验证，并且在验证成功后设置了经过用户 ID 签名的 cookie。
   # 尝试建立新连接时，会自动把 cookie 发送给连接实例，用于设置 current_user。通过使用 current_user 标识连接，我们稍后就能够检索指定用户打开的所有连接（如果删除用户或取消对用户的授权，该用户打开的所有连接都会断开）。
  end
end
