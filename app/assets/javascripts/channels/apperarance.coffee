App.apperarance = App.cable.subscriptions.create "ApperaranceChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
    # Called when there's incoming data on the websocket for this channel
 

 # # 当服务器上的订阅可用时调用
 #  connected: ->
 #    @install()
 #    @appear()

 #  # 当 WebSocket 连接关闭时调用
 #  disconnected: ->
 #    @uninstall()

 #  # 当服务器拒绝订阅时调用
 #  rejected: ->
 #    @uninstall()

 #  appear: ->
 #    # 在服务器上调用 `AppearanceChannel#appear(data)`
 #    @perform("appear", appearing_on: $("main").data("appearing-on"))

 #  away: ->
 #    # 在服务器上调用 `AppearanceChannel#away`
 #    @perform("away")


 #  buttonSelector = "[data-behavior~=appear_away]"

 #  install: ->
 #    $(document).on "page:change.appearance", =>
 #      @appear()

 #    $(document).on "click.appearance", buttonSelector, =>
 #      @away()
 #      false

 #    $(buttonSelector).show()

 #  uninstall: ->
 #    $(document).off(".appearance")
 #    $(buttonSelector).hide()
