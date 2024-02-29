require 'uri'
require 'net/http'

class Gpt3Controller < ApplicationController

  def humanize
    if params[:prompt]
      start_writing_prompt = "Generate a conversation with ChatGPT where a student seeks advice on completing homework efficiently. The conversation should cover time management techniques, effective study habits, and tips for staying focused. Include prompts for practical solutions and actionable steps that the student can implement to finish their homework quickly while maintaining academic integrity and understanding of the material. Show complete results. Compose this reply adopting a writing style akin to that of a college student. Achieve a harmonious blend of relatability and sophistication to seamlessly integrate it into the tone of a college paper or assignment."

      initialDialogue = [
        { role: "system", content: "The following is a conversation with an AI Writing Assistant called 'Cheko' that helps students do their homework, save time, and graduate. The assistant is helpful, creative, clever, informative, and very friendly. Cheko started in 2019 when a college student wanted to improve students’ lives." },
        { role: "assistant", content: "Hello! I'm Cheko, an AI-powered writing assistant to help you finish your homework fast!"},
        { role:"user", content:start_writing_prompt }
      ]
      section_content = Llm.go(prompts:initialDialogue)
      initialDialogue.append({role:"assistant",content:"#{section_content}"})

      # 2. Turn prompt into a message object
      prompt = {role: "user", content: "Humanize this: #{params[:prompt]}"}
      initialDialogue.append(prompt)

      response = Llm.go(prompts:initialDialogue,is_full_prompt: true)

      generated_text = response.dig("choices", 0, "message", "content")
      newDialogue = initialDialogue.concat([response.dig("choices", 0, "message")])

      usage = {
        completion_tokens: response.dig("usage", "completion_tokens"),
        prompt_tokens: response.dig("usage", "prompt_tokens"),
        total_tokens: response.dig("usage", "total_tokens"),
        model: response.dig("model")
      }

      render json: {markdown_text: Conversation.markdown_to_html(generated_text), generated_text: generated_text, new_dialogue: newDialogue, usage: usage}
    end
  end

  def generate
    content = generate_answer(params)
    serp_results = Serp.search(params[:prompt])
    render json: {content: content, sources: serp_results[0], related_questions: serp_results[1]}
  end

  def rewrite
    content = generate_answer(params, true)
    serp_results = Serp.search(params[:prompt])
    render json: {content: content, sources: serp_results[0], related_questions: serp_results[1]}
  end

  def save_conversation
    if user_signed_in?
      convo = Conversation.new

      convo.title_name = params[:title]
      convo.messages = params[:new_dialogue]
      convo.user_messages = params[:user_messages]
      convo.assistant_messages = params[:assistant_messages]
      convo.user_id = current_user.id

      convo.save

      save_related_list(convo, params)
      save_source_list(convo, params)

      render json: convo
    else
      render json: {error: "You need to sign in before saving a convo. Please sign in."}, status: 422
    end
  end

  def update_title
    if user_signed_in?
      convo = Conversation.find(params[:id])

      convo.title_name = params[:title]
      convo.save

      render json: convo
    else
      render json: {error: "You need to sign in before saving a convo. Please sign in."}, status: 422
    end
  end

  def update_conversation
    if user_signed_in?
      convo = Conversation.find(params[:id])

      convo.title_name = params[:title]
      convo.messages = params[:new_dialogue]
      convo.user_messages = params[:user_messages]
      convo.assistant_messages = params[:assistant_messages]
      convo.save

      save_related_list(convo, params)
      save_source_list(convo, params)

      render json: convo
    else
      render json: {error: "You need to sign in before saving a convo. Please sign in."}, status: 422
    end
  end

  def render_better_answer_bubble
    render partial: 'better_answer'
  end

  def index
    if params[:conversation_id].present?
      @conversation = Conversation.find(params[:conversation_id])
      @sources = @conversation.conversation_sources
      @relates = @conversation.conversation_relateds
    end
  end

  private

  def save_source_list(convo, params)
    if params[:source_list].present?
      params[:source_list].each do |source|
        puts "source[:prompt] #{source[:prompt]}"
        puts "source['prompt'] #{source['prompt']}"
        puts "source[''prompt''] #{source["prompt"]}"
        conversation_source = convo.conversation_sources.find_or_initialize_by(
          conversation_id: convo.id,
          prompt_title: source[:prompt]
        )
        conversation_source.result = source[:results]
        conversation_source.save
      end
    end
  end

  def save_related_list(convo, params)
    if params[:related_list].present?
      params[:related_list].each do |relate|
        conversation_related = convo.conversation_relateds.find_or_initialize_by(
          conversation_id: convo.id,
          prompt_title: relate[:prompt],
          )
        conversation_related.result = relate[:results]
        conversation_related.save
      end
    end
  end

  def generate_answer(params, rewrite=false)

    start_writing_prompt = "Generate a conversation with ChatGPT where a student seeks advice on completing homework efficiently. The conversation should cover time management techniques, effective study habits, and tips for staying focused. Include prompts for practical solutions and actionable steps that the student can implement to finish their homework quickly while maintaining academic integrity and understanding of the material. Show complete results"

    # 1. Default
    max_count_of_retries = 3
    retry_count = 0
    begin
      initialDialogue = [
        { role: "system", content: "The following is a conversation with an AI Writing Assistant called 'Cheko' that helps students do their homework, save time, and graduate. The assistant is helpful, creative, clever, informative, complete and very friendly. Cheko started in 2019 when a college student wanted to improve students’ lives." },
        { role: "assistant", content: "Hello! I'm Cheko, an AI-powered writing assistant to help you finish your homework fast!"},
        { role:"user", content:start_writing_prompt }
      ]

      section_content = Llm.go(prompts:initialDialogue)
      initialDialogue.append({role:"assistant",content:section_content})

      # 2. Turn prompt into a message object
      prompt = {role: "user", content: params[:prompt]}
      initialDialogue.append(prompt)

      if rewrite
        initialDialogue.append({role:"assistant",content:params[:current_result]})
        initialDialogue.append({role:"user",content:"please show different result for this prompt: #{params[:prompt]}"})
      end

      # 3. Initialize/Extend currentDialogue
      # currentDialogue = params[:currentDialogue].nil? ? initialDialogue.concat([prompt]) : params[:currentDialogue].concat([prompt])

      # 4. REQUEST via PERPLEXITY.AI API
      response = Llm.go(prompts:initialDialogue,is_full_prompt: true)

      # 5. Process OpenAI RESPONSE / PERLEXITY.AI RESPONSE
      generated_text = response.dig("choices", 0, "message", "content")

      newDialogue = initialDialogue.concat([response.dig("choices", 0, "message")])

      raise StandardError if generated_text.include?('cheko') || generated_text.include?('Cheko')

      usage = {
        completion_tokens: response.dig("usage", "completion_tokens"),
        prompt_tokens: response.dig("usage", "prompt_tokens"),
        total_tokens: response.dig("usage", "total_tokens"),
        model: response.dig("model")
      }

      return { markdown_text: Conversation.markdown_to_html(generated_text), generated_text: generated_text, new_dialogue: newDialogue, usage: usage}
    rescue => e
      puts e
      retry_count += 1
      if retry_count <= max_count_of_retries
        retry
      end
    end
  end
end