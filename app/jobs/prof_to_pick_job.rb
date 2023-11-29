class ProfToPickJob < ApplicationJob
  queue_as :default

  def perform(type, user)
    @user = user
    if type == "review_recieved"
      ProfToPickMailer.with(user: @user).review_recieved.deliver_now
    end
  end
end
