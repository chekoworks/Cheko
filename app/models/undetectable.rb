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
end