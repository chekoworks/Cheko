class NotifyUserJob < ApplicationJob
  queue_as :default

  def perform(qna)
    QnaMailer.with(qna: qna).notify_user.deliver_now
  end
end
