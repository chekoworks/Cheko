class HomeworkUpdateChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "some_channel"
    stream_from "homework_update_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
