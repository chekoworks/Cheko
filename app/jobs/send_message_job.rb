class SendMessageJob < ApplicationJob
  queue_as :default
  include Rails.application.routes.url_helpers
  def perform(message, type, chat_id, opt={})
    document = opt[:document_url].present? ? opt[:document_url] : nil
    
    ActionCable.server.broadcast("message_channel_#{chat_id}", html: opt[:message].present? ? opt[:message] : message.content, type: type, document: document) 
  end
end
