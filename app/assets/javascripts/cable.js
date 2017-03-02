// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the rails generate channel command.
//
//= require action_cable
//= require_self
//= require_tree ./channels
//用户需要在客户端创建连接实例。下面这段由 Rails 默认生成的 JavaScript 代码，正是用于在客户端创建连接实例：
(function() {
  this.App || (this.App = {});

  App.cable = ActionCable.createConsumer();

}).call(this);
