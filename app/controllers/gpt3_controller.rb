require 'uri'
require 'net/http'

class Gpt3Controller < ApplicationController

  def humanize
    if params[:prompt]
      @content = generate_answer(params, false, false, true)
      if @content.nil?
        @content = generate_answer(params, false, true, true)
      end
    end

    render json: @content[:content]
  end

  def generate
    threads = []
    @content = nil
    @content = generate_answer(params)
    if @content.nil?
      @content = generate_answer(params, false, true)
    end
    render json: @content
  end

  def rewrite
    content = generate_answer(params, true)
    render json: content
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
  rescue ActiveRecord::RecordNotFound
    convo = save_convo(params.except(:id))
    render json: convo
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



  def delete_conversation
    if params[:conversation_id].present?
      ActiveRecord::Base.transaction do
        @conversation = Conversation.find(params[:conversation_id])
        @conversation.conversation_sources.destroy_all
        @conversation.conversation_relateds.destroy_all

        @conversation.destroy
      end
    end
  end

  private

  def save_convo(params)
    convo = Conversation.new

    convo.title_name = params[:title]
    convo.messages = params[:new_dialogue]
    convo.user_messages = params[:user_messages]
    convo.assistant_messages = params[:assistant_messages]
    convo.user_id = current_user.id

    convo.save

    save_related_list(convo, params)
    save_source_list(convo, params)

    convo
  end

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

  def generate_answer(params, rewrite=false, retry_request=false, humanize=false)

    start_writing_prompt = "Generate a conversation where a student seeks advice on completing homework efficiently. The conversation should cover time management techniques, effective study habits, and tips for staying focused. Include prompts for practical solutions and actionable steps that the student can implement to finish their homework quickly while maintaining academic integrity and understanding of the material. \n\n When it comes to writing content, two factors are crucial, “perplexity” and “burstiness.” Perplexity measures the complexity of text. Separately, burstiness compares the variations of sentences. Humans tend to write with greater burstiness, for example, with some longer or complex sentences alongside shorter ones. AI sentences tend to be more uniform. Therefore, when writing the following content I am going to ask you to create, I need it to have a good amount of perplexity and burstiness. Do you understand? Show complete results."
    generate_prompt = "I want to learn how to complete homework efficiently and avoid procrastination. Can you help me with time management techniques, effective study habits, and staying focused?\n\nPerplexity AI: Of course! I'm delighted to share actionable steps and practical advice to help you excel in your academics. To maximize efficiency and minimize stress, here are some tips I've gathered:\n\n1. Time Management Techniques:\n   - Break tasks into smaller chunks, following the Pomodoro Technique: Work in 25-minute intervals, with short breaks in between to prevent burnout.\n   - Prioritize tasks based on urgency and importance. Don't forget to integrate self-care and relaxation time into your schedule.\n\n2. Effective Study Habits:\n   - Active recall: Actively test your knowledge by summarizing or rephrasing content to ensure better retention.\n   - Interleaved practice: Mix different topics instead of sticking to one subject only. This helps in recognizing patterns that apply to various subjects.\n   - Elaborative encoding: Develop your understanding by relating new concepts to existing knowledge, generating your own examples, and analogies.\n\n3. Staying Focused:\n   - Reduce distractions: Minimize digital noise and eliminate external distractions. Set up 'focus hours' dedicated to study and reduce social media usage.\n   - Practice mindfulness and gratitude: Being grateful for the opportunity to learn and complete your homework can improve your focus and productivity.\n   - Set achievable goals for each study session. Create small wins and reward yourself after accomplishing milestones.\n\nI hope these tips are useful to you. Remember to approach your studies with an open. Add confidence score/percentage on the end of the answer/response with 2 next line spacing."
    # 1. Default
    max_count_of_retries = 1
    retry_count = 0
    begin
      @serp_results = Serp.search(params[:prompt])
      additional_prompt = "
        Here are some source links to be use to generate an answer: #{@serp_results[0].pluck(:link).join(', ')}.
        Get the direct answer and make it 1 paragraph short and 250 max words.
        If there are formatting please add some markdown.
        Make the answer humanize and easier to read.
      "
      generate_prompt += additional_prompt
      initialDialogue = [
        { role: "system", content: "The following is a conversation with an AI Writing Assistant called 'Cheko' that helps students do their homework, save time, and graduate. The assistant is helpful, creative, clever, informative, complete and very friendly. Cheko started in 2019 when a college student wanted to improve students’ lives. Hello! I'm Cheko, an AI-powered writing assistant to help you finish your homework fast!" },
        { role:"user", content:start_writing_prompt },
        { role:"assistant",content:generate_prompt }
      ]
      if humanize
        initialDialogue.append({ role: "user", content: "Humanize this: #{params[:prompt]}" })
      else
        initialDialogue.append({ role: "user", content: params[:prompt] })
      end

      if rewrite
        initialDialogue.append({role:"assistant",content:params[:current_result]})
        initialDialogue.append({role:"user",content:"please show different result for this prompt: #{params[:prompt]}"})
      end

      # 3. Initialize/Extend currentDialogue
      # currentDialogue = params[:currentDialogue].nil? ? initialDialogue.concat([prompt]) : params[:currentDialogue].concat([prompt])

      # 4. REQUEST via PERPLEXITY.AI API
      if retry_request
        response = Llm.go(prompts:initialDialogue,is_full_prompt: true, model: 'sonar-medium-chat')
      else
        response = Llm.go(prompts:initialDialogue,is_full_prompt: true)
      end

      puts response

      # 5. Process OpenAI RESPONSE / PERLEXITY.AI RESPONSE
      generated_text = response.dig("choices", 0, "message", "content").gsub("Perplexity AI: ", "")

      newDialogue = initialDialogue.concat([response.dig("choices", 0, "message")])

      raise StandardError if generated_text.include?('cheko') || generated_text.include?('Cheko')

      usage = {
        completion_tokens: response.dig("usage", "completion_tokens"),
        prompt_tokens: response.dig("usage", "prompt_tokens"),
        total_tokens: response.dig("usage", "total_tokens"),
        model: response.dig("model")
      }

      return {
        content: {
          markdown_text: Conversation.markdown_to_html(generated_text),
          generated_text: generated_text,
          new_dialogue: newDialogue,
          usage: usage
        },
        sources: @serp_results[0],
        related_questions: @serp_results[1]
      }
    rescue => e
      puts e
      retry_count += 1
      if retry_count <= max_count_of_retries
        retry
      end
    end
  end
end