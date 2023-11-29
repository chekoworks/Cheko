class Users::MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    chat = Chat.find(params[:chat_id])
    qna = Qna.find(params[:qna_id])

    if current_user.id == qna.user_id
      message = Message.new(content: params[:message][:content], chat_id: chat.id, document: params[:message][:document], sendable_type: "User")
      if message.save
        SendMessageJob.perform_now(message, "User", chat.id, { document_url: message.document.attached? ? rails_blob_path(message.document, disposition: 'attachment') : nil })
      else
        SendMessageJob.perform_now(message, "Error User", chat.id, { message: message.errors.full_messages, document_url: message.document.attached? ? rails_blob_path(message.document, disposition: 'attachment') : nil })
      end
    end
  end

  def destroy
  end
end
