require 'uri'
require 'net/http'

class Llm
  #TODO
  #warn us if out of credits
  #better error handling on timeout
  #better retry logic

  # old client
  def self.old_client opts={}
    key = ENV["OPEN_AI_TOKEN"] || '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'
    url = URI("https://api.perplexity.ai/chat/completions")
    prompts = opts[:prompts]
    prompt = opts[:prompt]
    model = opts[:model] || "pplx-7b-online"

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Post.new(url)
    request["accept"] = 'application/json'
    request["content-type"] = 'application/json'
    request["authorization"] = "Bearer #{key}"
    if prompts.kind_of?(Array)
      request.body = {:model => model, :messages => prompts}.to_json
    else
      request.body = {:model => model, :messages => [{role: "user", content: prompt}]}.to_json
    end
    response = http.request(request)
    JSON.parse(response.body)
  end
  def self.go opts={}
    prompts = opts[:prompts]
    prompt = opts[:prompt]
    model = opts[:model] || "sonar-small-chat"
    is_full_prompt = opts[:is_full_prompt] || false
    max_attempts = opts[:max_attempts] || 1
    is_different_model = opts[:is_different_model] || false
    is_openai_client = false
    attempts = 0
    full_prompt = "#{model}#{prompts}#{prompt}"
    begin
      opts[:model] = model
      if is_openai_client
        r = Llm.openai_client opts
      else
        r = Llm.pplx_client opts
      end
      if r["error"].present?
        puts "problem running prompt: #{r['error']}"
      else
        puts r
        if is_full_prompt
          r
        else
          r["choices"][0]["message"]["content"]
        end
      end
    rescue Exception => e
      if attempts < max_attempts
        puts "retrying attempt #{attempts} for #{full_prompt} #{e}"+e.backtrace.join("\n")
        attempts += 1
        sleep(attempts * 5)
        retry
      else
        if !is_openai_client
          is_openai_client = true
          attempts = 0
        else
          puts "out of attempts for #{full_prompt} #{e} #{e.backtrace.join('\n')}"
        end
      end
    end
  end

  def self.pplx_client opts={}
    hydra = Typhoeus::Hydra.new

    key = ENV["PERPLEXITY_AI_TOKEN"] || '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'
    url = URI("https://api.perplexity.ai/chat/completions")
    prompts = opts[:prompts]
    prompt = opts[:prompt]
    model = opts[:model] || "sonar-small-chat"

    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    # request = Net::HTTP::Post.new(url)
    request_body = {:model => model, :messages => [{role: "user", content: prompt}]}.to_json
    if prompts.kind_of?(Array)
      request_body = {:model => model, :messages => prompts}.to_json
    end

    pplx_request = Typhoeus::Request.new(
      "https://api.perplexity.ai/chat/completions",
      method: :post,
      body: request_body,
      headers: { Accept: "application/json", "Content-Type": 'application/json', "Authorization": "Bearer #{key}" }
    )

    hydra.queue pplx_request
    hydra.run

    JSON.parse(pplx_request.response.body)
  end

  def self.openai_client opts={}
    key = ENV["OPEN_AI_TOKEN"] || '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'
    prompts = opts[:prompts]
    prompt = opts[:prompt]
    model = opts[:model] || "gpt-4"

    client = OpenAI::Client.new(access_token: key)

    request_body = [{role: "user", content: prompt}]
    if prompts.kind_of?(Array)
      request_body = prompts
    end

    response = client.chat(
      parameters: {
        model: model, # Required.
        messages: request_body, # Required.
        temperature: 0.7,
      })

    response
  end

end