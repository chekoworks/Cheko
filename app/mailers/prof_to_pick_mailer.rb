class ProfToPickMailer < ApplicationMailer
  default from: 'admin@cheko.com'
  layout 'mailer'

  def review_recieved
    @user = params[:user]
    mail(to: @user.email, subject: "Profs to Pick Review")
  end
end
