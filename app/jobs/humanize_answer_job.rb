class HumanizeAnswerJob < ApplicationJob
  queue_as :default

  def perform(answer, conversation_id, position)
    max_attempts = 3
    attempts = 0
    begin
      undetectable_ai_id = Undetectable.humanize(answer)
      raise StandardError if undetectable_ai_id.nil?

      humanize_answer = HumanizeAnswer.new

      humanize_answer.position = position
      humanize_answer.conversation_id = conversation_id
      humanize_answer.undetectable_ai_id = undetectable_ai_id
      humanize_answer.position = position

      humanize_answer.save
    rescue Exception => e
      if attempts < max_attempts
        puts "retrying attempt #{attempts} for #{answer} #{e}"+e.backtrace.join("\n")
        attempts += 1
        sleep(attempts * 5)
        retry
      else
        puts "out of attempts for #{answer} #{e} #{e.backtrace.join('\n')}"
      end
    end
  end
end