class NotifyTmMailerJob < ApplicationJob
  queue_as :default

  def perform(type, team_manager)
    if type == "new_order"
      NotifyTmMailer.new_order(team_manager).deliver_now
    end
  end
end
