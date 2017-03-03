class GuestsCleanupJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
  end
    #可用的回调 aop
	# before_enqueue
	# around_enqueue
	# after_enqueue
	# before_perform
	# around_perform
	# after_perform 
  #作业各种各样，可以是定期清理、账单支付和寄信。其实，任何可以分解且并行运行的工作都可以
  #Rails 默认实现了立即运行的队列运行程序。因此，队列中的各个作业会立即运行。
  # queue_as :default

  #create job #rails generate job guests_cleanup 


  #注意，perform 方法的参数是任意个
  # 入队作业，作业在队列系统空闲时立即执行
  # GuestsCleanupJob.perform_later guest
# # 入队作业，在明天中午执行
# GuestsCleanupJob.set(wait_until: Date.tomorrow.noon).perform_later(guest)
# # 入队作业，在一周以后执行
# GuestsCleanupJob.set(wait: 1.week).perform_later(guest)
# # `perform_now` 和 `perform_later` 会在幕后调用 `perform`
# # 因此可以传入任意个参数
# GuestsCleanupJob.perform_later(guest1, guest2, filter: 'some_filter')


# Active Job 与 Action Mailer 是集成的，因此可以轻易异步发送电子邮件：

# # 如需想现在发送电子邮件，使用 #deliver_now
# UserMailer.welcome(@user).deliver_now

# # 如果想通过 Active Job 发送电子邮件，使用 #deliver_later
# UserMailer.welcome(@user).deliver_later

#Active Job 支持参数使用 GlobalID。这样便可以把 Active Record 对象传给作业
# class TrashableCleanupJob < ApplicationJob
#   def perform(trashable, depth)
#     trashable.cleanup(depth)
#   end
# end

#Active Job 允许捕获执行作业过程中抛出的异常：
 rescue_from(ActiveRecord::RecordNotFound) do |exception|
   # 处理异常
  end

end
