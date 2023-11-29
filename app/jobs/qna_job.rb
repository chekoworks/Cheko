class QnaJob < ApplicationJob
  queue_as :default

  def perform(type, tutor, qna)
    @qna = qna
    if type == "new_qna"
      QnaMailer.with(qna: @qna).new_qna(tutor).deliver_now
    elsif type == "booked_order"
      QnaMailer.with(qna: @qna).booked_order.deliver_now
    elsif type = "notify_user"
      QnaMailer.with(qna: @qna).notify_user.deliver_now
    end
  end
end