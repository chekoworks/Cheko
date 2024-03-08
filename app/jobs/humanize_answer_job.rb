class HumanizeAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer, conversation_id, position)
    undetectable_ai_id = Undetectable.humanize(answer)
    humanize_answer = HumanizeAnswer.new

    humanize_answer.position = position
    humanize_answer.conversation_id = conversation_id
    humanize_answer.undetectable_ai_id = undetectable_ai_id
    humanize_answer.position = position

    humanize_answer.save

  end
end