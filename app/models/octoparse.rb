class Octoparse

  def self.perplexity_task_id
    "73c3ce2d-469d-8036-26cb-4392d17fadd4"
  end

  def self.octoparse_url
    "https://openapi.octoparse.com"
  end

  def self.api_email_address
    "dave.uygongco@student.ateneo.edu"
  end

  def self.api_password
    "77octo-ChekoAI"
  end

  def self.get_token
    url = octoparse_url + '/token'
    conn = Faraday.new(
      url: url,
      headers: {'Content-Type' => 'application/json'}
    )

    response = conn.post() do |req|
      req.body = {
        username: api_email_address,
        password: api_password,
        grant_type: "password"
      }.to_json
    end


    response_json = JSON.parse(response.body)

    return response_json['data']['access_token']
  end

  def self.change_text_search(chat_text)
    action_id = 'jz8xm59zutf'
    url = octoparse_url + '/task/updateActionProperties'
    authorization_token_key = get_token
    conn = Faraday.new(
      url: url,
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{authorization_token_key}"
      }
    )

    response = conn.post() do |req|
      req.body = {
          "taskId": Octoparse.perplexity_task_id,
          "actions": [
            {
              "actionType": "EnterTextAction",
              "actionId": action_id,
              "properties": [
                {
                  "name": "TextToSet",
                  "value": chat_text
                }
              ]
            }
          ]
        }.to_json
    end


    # response_json = JSON.parse(response.body)

    return response.status == 200
  end

  def self.start_task(chat_text)
    is_text_updated = Octoparse.change_text_search(chat_text)

    if is_text_updated
      url = octoparse_url + '/cloudextraction/start'
      authorization_token_key = get_token
      conn = Faraday.new(
        url: url,
        headers: {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{authorization_token_key}"
        }
      )

      response = conn.post() do |req|
        req.body = {
          "taskId": Octoparse.perplexity_task_id
        }.to_json
      end
    end

    return nil
  end

  def self.get_non_exported_data
    url = octoparse_url + '/data/notexported'
    authorization_token_key = get_token
    conn = Faraday.new(
      url: url,
      headers: {
        'Authorization' => "Bearer #{authorization_token_key}"
      }
    )

    response = conn.get() do |req|
      req.params['taskId'] = Octoparse.perplexity_task_id
      req.params['size'] = 1000
    end

    response_json = JSON.parse(response.body)
    data = response_json['data']['data']

    # return data[0]['Text'] != '' ? data[0]['Text'] : data[1]['Text']
    return {text: data.last['Text'], data_size: data.size}
  end

  def self.get_actions
    url = octoparse_url + '/task/getActions'
    authorization_token_key = get_token
    conn = Faraday.new(
      url: url,
      headers: {
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{authorization_token_key}"
      }
    )

    response = conn.post() do |req|
      req.body = {
          "taskIds": [
            Octoparse.perplexity_task_id
          ],
          "actionTypes": %w[LoopAction NavigateAction EnterTextAction]
        }.to_json
    end


    # response_json = JSON.parse(response.body)

    return response
  end

end