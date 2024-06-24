class Api < ApplicationRecord
  def self.api_url
    "https://cheko-ai-backend.onrender.com/"
  end

  def self.connection(path)
    url = Api.api_url + path
    Faraday.new(
      url: url,
      headers: {
        'Content-Type' => 'application/json'
      }
    )
  end

  def self.post_request(path, content)
    conn = Api.connection(path)
    response = conn.post() do |req|
      req.body = {
        "role": "user",
        "content": content
      }.to_json
    end

    JSON.parse(response.body)
  end


  def self.custom_post_request(path, body)
    conn = Api.connection(path)
    response = conn.post() do |req|
      req.body = body.to_json
    end

    JSON.parse(response.body)
  end

  def self.get_request(path, content)
    conn = Api.connection(path)
    response = conn.get() do |req|
      req.body = {
        "role": "user",
        "content": content
      }.to_json
    end

    JSON.parse(response.body)
  end
end