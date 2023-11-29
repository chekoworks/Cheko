class AcceptQnaChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    # stream_from "accept_qna_channel_#{params[:chat_id]}" 

  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
