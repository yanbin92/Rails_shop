# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ProductsChannel < ApplicationCable::Channel
  #Action Cable 将 WebSocket 与 Rails 应用的其余部分无缝集成。有了 Action Cable，我们就可以用 Ruby 语言，以 Rails 风格实现实时功能，并且保持高性能和可扩展性。Action Cable 为此提供了全栈支持，包括客户端 JavaScript 框架和服务器端 Ruby 框架。同时，我们也能够通过 Action Cable 访问使用 Active Record 或其他 ORM 编写的所有模型
  #Pub/Sub 
  #自己的频道类 这样用户就可以订阅频道了，订阅一个或两个都行。
  #订阅频道的用户称为订阅者。用户创建的连接称为（频道）订阅。订阅基于连接用户（订阅者）发送的标识符创建，生成的消息将发送到这些订阅。
  def subscribed
    # stream_from "some_channel"
    #客户端-服务器的交互 频道把已发布内容（即广播）发送给订阅者，是通过所谓的“流”机制实现的。
    #创建订阅时，可以从客户端向服务器端传递参数  stream_from "chat_#{params[:room]}"
    stream_from "products"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
  #WebSocket 服务器没有访问会话的权限，但可以访问 cookie，而在处理身份验证时需要用到 cookie。这篇文章介绍了如何使用 Devise 验证身份
  #  消息重播

	# 一个客户端向其他已连接客户端重播自己收到的消息，是一种常见用法。

	# # app/channels/chat_channel.rb
	# class ChatChannel < ApplicationCable::Channel
	#   def subscribed
	#     stream_from "chat_#{params[:room]}"
	#   end

	#   def receive(data)
	#     ActionCable.server.broadcast("chat_#{params[:room]}", data)
	#   end
	# end
	# # app/assets/javascripts/cable/subscriptions/chat.coffee
	# App.chatChannel = App.cable.subscriptions.create { channel: "ChatChannel", room: "Best Room" },
	#   received: (data) ->
	#     # data => { sent_by: "Paul", body: "This is a cool chat app." }

	# App.chatChannel.send({ sent_by: "Paul", body: "This is a cool chat app." })
end
