class Undetectable
  def self.api_key
    "1700976779934x378118977479095900"
  end

  def self.undetectable_url
    "https://api.undetectable.ai"
  end

  def self.submit(content)
    url = undetectable_url + '/submit'
    conn = Faraday.new(
      url: url,
      headers: {
        'Content-Type' => 'application/json',
        'api-key' => api_key
      }
    )
    response = conn.post() do |req|
      req.body = {
        "content": content,
        "readability": "High School",
        "purpose": "General Writing",
        "strength": "More Human"
      }.to_json
    end

    JSON.parse(response.body)
  end

  def self.retrieve(id)
    url = undetectable_url + '/document'
    conn = Faraday.new(
      url: url,
      headers: {
        'Content-Type' => 'application/json',
        'api-key' => api_key
      }
    )
    response = conn.post() do |req|
      req.body = {
        "id": id
      }.to_json
    end

    JSON.parse(response.body)
  end

  def self.humanize(content)
    response_params = submit(content)

    if response_params
      puts response_params
      # retrieved_response = retrieve(response_params['id'])
      return response_params['id']
    end

    return nil
  end

  def self.check_and_save_humanized_answer
    puts "Start checking for humanized answer...."
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

        ActionCable.server.broadcast("humanize_answer_channel_#{conversation.user.id}", {conversation: conversation})
      end
    end

    puts "Done processing humanized answers: #{undone_humanize_answers.length}"
    Rails.logger.info("Done processing humanized answers: #{undone_humanize_answers.length}")
  end
end