require 'test_helper'

class GuestsCleanupJobTest < ActiveJob::TestCase
  #因为自定义的作业在应用的不同层排队，所以我们既要测试作业本身（入队后的行为），也要测试是否正确入队了。
   test 'that account is charged' do
     # GuestsCleanupJobTest.perform_now(account, product)
    # assert account.reload.charged_for?(product)
  end
  #默认情况下，ActiveJob::TestCase 把队列适配器设为 :async，
  #因此作业是异步执行的。此外，在运行任何测试之前，它会清理之前执行的和入队的作业，因此我们可以放心假定在当前测试的作用域中没有已经执行的作业。


  #test "the truth" do
  #   assert true
  # end
end
