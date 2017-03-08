require 'test_helper'

class OrderMailerTest < ActionMailer::TestCase
  test "received" do
    mail = OrderMailer.received(orders(:one))
    # byebug
    # 发送邮件，测试有没有入队
    assert_emails 1 do
        mail.deliver_now
    end
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
    assert_equal ["ybinbin@outlook.com"], mail.to
    assert_equal ["18036096795@163.com"], mail.from
    #assert_match /1 x Programming Ruby 1.9/, mail.body.encoded
  end

  test "shipped" do
    mail = OrderMailer.shipped(orders(:one))
    assert_equal "Pragmatic Store Order Shipped", mail.subject
    assert_equal ["ybinbin@outlook.com"], mail.to
    assert_equal ["18036096795@163.com"], mail.from
    #assert_match /<td>1&times;<\/td>\s*<td>Programming Ruby 1.9<\/td>/, mail.body.encoded
  end

end
