class CheckAndSaveHumanizedAnswerJob < ApplicationJob
  queue_as :default

  def perform
    Rails.logger.info("Start checking for humanized answer....")
    undetectable_request_limit = 3
    undone_humanize_answers = HumanizeAnswer.where(humanized_output: nil).limit(undetectable_request_limit)

    threads = []
    undone_humanize_answers.each do |humanize_answer|
      document = Undetectable.retrieve(humanize_answer.undetectable_ai_id)
      if document['output'].present?
        humanize_answer.humanized_output = document['output']
        humanize_answer.save

        conversation = humanize_answer.conversation

        conversation.user_messages = conversation.user_messages.insert(humanize_answer.position + 1, 'Humanizing answer... Please wait for 1-3 minutes...')
        conversation.assistant_messages = conversation.assistant_messages.insert(humanize_answer.position + 1, document['output'])

        conversation.save

        # HumanizeAnswerChannel.broadcast_to(
        #   conversation.user,
        #   {conversation: conversation}
        # )
        ActionCable.server.broadcast("humanize_answer_channel_#{conversation.user.id}", {conversation: conversation})
      end
    end

    Rails.logger.info("Done processing humanized answers: #{undone_humanize_answers.length}")
  end
end