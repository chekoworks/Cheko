 class NotifyTutorMailer < ApplicationMailer
  default from: 'admin@cheko.com'
  layout 'mailer'

  def new_order(tutor)
    @homework = params[:homework]
    @tutor = tutor
    mail(to:@tutor.email, subject: "HW-Help Order #{@homework.id} - Up for Bidding")
  end

  def approved_bid(tutor)
    @homework = params[:homework]
    @tutor = tutor
    mail(to:@tutor.email, subject: "HW-Help Order #{@homework.id} - Assigned")
  end
  
end
