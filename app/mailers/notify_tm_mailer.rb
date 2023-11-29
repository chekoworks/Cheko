class NotifyTmMailer < ApplicationMailer
  default from: 'admin@cheko.com'
  layout 'mailer'

  def new_order(team_manager)
    mail(to: team_manager.email, subject: "New Order")
  end
end
