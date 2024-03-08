class HumanizeAnswerChannel < ApplicationCable::Channel
  def subscribed
    stream_from 'humanize_answer_channel'
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end