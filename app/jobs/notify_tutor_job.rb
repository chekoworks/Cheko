class NotifyTutorJob < ApplicationJob
  queue_as :default

  def perform(type, tutor, homework)  
    @homework = homework  
    if type == "new_order"
      NotifyTutorMailer.with(homework: @homework).new_order(tutor).deliver_now
    elsif type == "approved_bid"
      NotifyTutorMailer.with(homework: @homework).approved_bid(tutor).deliver_now
    end
  end

end
