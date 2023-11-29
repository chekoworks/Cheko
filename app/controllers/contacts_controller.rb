class ContactsController < ApplicationController
  def create
    @contact = Contact.create(contact_params)
    ApplicationMailer.contact_email(@contact).deliver_now
    redirect_to root_path
  end

  private

  def contact_params
    params.require(:contact).permit(:full_name, :email, :phone_number, :message)
  end
end
