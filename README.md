# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...
#at begin run 
rails db:seed  
bundle install #restart server
 
rails test:integration  #集成测试
#rails g mailer Order received shipped
#rails  g integration_test user_stories
#TODO 订单确认邮件 没发出去 待排查  test:integration
#bin/rails generate scaffold User name:string password:digest

sqlite3 -line db/development.sqlite3 "select * from users
 It turns out that it’s easy to implement using the Rails
callback facility   过滤器 限制访问
#
> bin/rails console
Loading development environment.
>> User.create(name: 'dave', password: 'secret', password_confirmation: 'secret')
=> #<User:0x2933060 @attributes={...} ... >
>> User.count
=> 1
#其实begin相当于java的try
#rescue相当于java的catch
#ensure相当于java的finaly
#raise相当于java的throw

usercontrol :it’s still possible for two administrators
each to delete the last two users if their timing is right. Fixing this
would require more database wizardry than we have space for here.


TODO playtime task I   fix test error

def sales_graph
	png_data = Sales.plot_for(Date.today.month)
	send_data(png_data, type: "image/png", disposition: "inline")
end

def send_secret_file
	send_file("/files/secret_list")
	headers["Content-Description"] = "Top secret"
end
#objects in a session must be
#serializable (using Ruby’s Marshal functions).
<!-- session_store = :cookie_store #4kb default
If you have a high-volume site, keeping the size of the session data small and
going with cookie_store is the way to go
session_store = :active_record_store
session_store = :drb_store
session_store = :mem_cache_store
session_store = :memory_store
session_store = :file_store -->

# If you’d like an easier way of dealing with uploading and storing images, take
#TODO use  Paperclip4 attachment_fu5 plugins 
#helpers method rails 
http://doc.rubyfans.com/rails/api/v4.1.0/

<%= link_to(image_tag("delete.png", size: "50x22"),
product_path(@product),
data: { confirm: "Are you sure?" },
method: :delete)
%>

<%= mail_to("support@pragprog.com", "Contact Support",
subject: "Support question from #{@user.name}",
encode: "javascript") %>
