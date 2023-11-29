class ApplicationMailer < ActionMailer::Base
  default from: 'admin@cheko.com'
  layout 'mailer'

  def contact_email(contact)
    @contact = contact
    mail(to:"chekofpm@gmail.com", subject: "Contact Form Submission")
  end
end