require 'uri'
require 'net/http'

class Llm
  #TODO
  #warn us if out of credits
  #better error handling on timeout
  #better retry logic
  def self.client opts={}
    key = ENV["PERPLEXITY_AI_TOKEN"] || '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'
    url = URI("https://api.perplexity.ai/chat/completions")
    prompts = opts[:prompts]
    prompt = opts[:prompt]
    model = opts[:model] || "mistral-7b-instruct"

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
    model = opts[:model] || "mistral-7b-instruct"
    is_full_prompt = opts[:is_full_prompt] || false
    max_attempts = opts[:max_attempts] || 1
    attempts = 0
    full_prompt = "#{model}#{prompts}#{prompt}"
    begin
      r = Llm.client opts
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
        puts "out of attempts for #{full_prompt} #{e} #{e.backtrace.join('\n')}"
      end
    end
  end

end