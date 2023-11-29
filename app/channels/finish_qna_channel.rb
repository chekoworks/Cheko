class FinishQnaChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "finish_qna_channel_#{params[:chat_id]}" 
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
