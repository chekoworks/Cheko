class HumanizeAnswerChannel < ApplicationCable::Channel
  def subscribed
    stream_from "humanize_answer_channel_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end