class Tutors::MessagesController < ApplicationController
  before_action :authenticate_tutor!
  
  def create
    chat = Chat.find(params[:chat_id])
    qna = Qna.find(params[:qna_id])

    if current_tutor.id == qna.tutor_id
      message = current_tutor.messages.new(content: params[:message][:content], chat_id: chat.id, document: params[:message][:document])
      if message.save
        SendMessageJob.perform_now(message, "Tutor", chat.id, { document_url: message.document.attached? ? rails_blob_path(message.document, disposition: 'attachment') : nil })
      else
        SendMessageJob.perform_now(message, "Error Tutor", chat.id, { message: message.errors.full_messages, document_url: message.document.attached? ? rails_blob_path(message.document, disposition: 'attachment') : nil })
      end
    end
  end

  private

  def msg_params
    params.require(:message).permit(:content, :document)
  end
end
