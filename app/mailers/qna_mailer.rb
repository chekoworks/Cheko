class QnaMailer < ApplicationMailer
  default from: 'admin@cheko.com'
  layout 'mailer'

  def notify_user
    @qna = params[:qna]
    mail(to: @qna.user.email, subject: "Q&A Order #{@qna.id} - Accepted")
  end

  def new_qna(tutor)
    @qna = params[:qna]
    @tutor = tutor
    mail(to: tutor.email, subject: "Q&A Order #{@qna.id} - Available")
  end

  def booked_order
    @qna = params[:qna]
    mail(to: @qna.user.email, subject: "Q&A Order #{@qna.id} - Processing")
  end

end
