class Gpt3Controller < ApplicationController
  def generate
    client = OpenAI::Client.new

    # 1. Default
    initialDialogue = [
      { role: "system", content: "The following is a conversation with an AI Writing Assistant called 'Cheko' that helps students do their homework, save time, and graduate. The assistant is helpful, creative, clever, informative, and very friendly. Cheko started in 2019 when a college student wanted to improve students’ lives." },
      { role: "assistant", content: "Hello! I'm Cheko, an AI-powered writing assistant to help you finish your homework fast!"},
    ]

    # 2. Turn prompt into a message object
    prompt = {role: "user", content: params[:prompt]}

    # 3. Initialize/Extend currentDialogue
    currentDialogue = params[:currentDialogue].nil? ? initialDialogue.concat([prompt]) : params[:currentDialogue].concat([prompt])

    # 4. REQUEST via OpenAI API
    response = client.chat(
      parameters: {
        model: "gpt-4-1106-preview",
        messages: currentDialogue,
      }
    )

    # 5. Process OpenAI RESPONSE
    generated_text = response.dig("choices", 0, "message", "content")
    puts response
    newDialogue = currentDialogue.concat([response.dig("choices", 0, "message")])

    usage = {
      completion_tokens: response.dig("usage", "completion_tokens"),
      prompt_tokens: response.dig("usage", "prompt_tokens"),
      total_tokens: response.dig("usage", "total_tokens"),
      model: response.dig("model")
    }

    render json: { generated_text: generated_text, new_dialogue: newDialogue, usage: usage}
  end

  def render_better_answer_bubble
    render partial: 'better_answer'
  end

  def index
  end
end
