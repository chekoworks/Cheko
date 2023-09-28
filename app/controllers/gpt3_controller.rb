class Gpt3Controller < ApplicationController
  def generate
    client = OpenAI::Client.new


    # 1. Default: Define an initial conversation dialogue between the user and the AI.
    initialDialogue = [
      { role: "system", content: "The following is a conversation with an AI Writing Assistant called 'Cheko' that helps students do their homework, save time, and graduate. The assistant is helpful, creative, clever, informative, and very friendly. Cheko started in 2019 when a college student wanted to improve students’ lives." },
      { role: "assistant", content: "Hello! I'm Cheko, an AI-powered writing assistant to help you finish your homework fast!"},
    ]

    # 2. Turn prompt into a message object: Create a message object from the user's input.
    prompt = { role: "user", content: params[:prompt] }
    
    # 3. Initialize/Extend currentDialogue: If there is an existing conversation, extend it with the user's message. Otherwise, start a new conversation with the initial dialogue followed by the user's message.
    currentDialogue = params[:currentDialogue].nil? ? initialDialogue.concat([prompt]) : params[:currentDialogue].concat([prompt])

    # 4. REQUEST via OpenAI API
    response = client.chat(
      parameters: {
        model: "gpt-4-0613",
        messages: currentDialogue,
      }
    )

    # 5. Process OpenAI RESPONSE
    generated_text = response.dig("choices", 0, "message", "content")
    newDialogue = currentDialogue.concat([response.dig("choices", 0, "message")])
    
    usage = {
      completion_tokens: response.dig("usage", "completion_tokens"),
      prompt_tokens: response.dig("usage", "prompt_tokens"),
      total_tokens: response.dig("usage", "total_tokens"),
      model: response.dig("model")
    }

    render json: { generated_text: generated_text, new_dialogue: newDialogue, usage: usage}
  end

  
  def humanize_text
    # this humanize the previous output bc it might sound ai generated. so on the backend you add a prompt like write this more in the style of a college student
    client = OpenAI::Client.new

    last_assistant_content = params[:currentDialogue].reverse.find { |item| item["role"] == "assistant" }["content"]
    puts "LAST ASSISTANT CONTENT: #{last_assistant_content}"

    prompt = "#{last_assistant_content} Write this more in the style of a college student."

    response = client.completions(
      engine: "davinci",
      prompt: prompt,
      max_tokens: 100,
      temperature: 0.9,
      top_p: 1,
      frequency_penalty: 0.0,
      presence_penalty: 0.6,
      stop: ["\n", "Student:"]
    )

    generated_text = response.dig("choices", 0, "text")
    puts "GENERATED TEXT: #{generated_text}"

    render json: { generated_text: generated_text }
     
  end
    
  def render_better_answer_bubble
    render partial: 'better_answer'
  end

  def index
  end
end