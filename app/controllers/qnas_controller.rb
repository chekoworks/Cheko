class QnasController < ApplicationController
  # def index
  #   @qnas = Qna.where("status = 0 OR status = 1")
  #   @finish = Qna.where(status: "done")
  # end

  def new
    # qna_old = Qna.find_by(auth: cookies[:tutor_qna])

    # if qna_old
    #   redirect_to qna_path(qna_old.id)
    # elsif params[:type].nil?
    #   redirect_to pick_type_qnas_path
    # else
      @qna = Qna.new
    # end
  end

  def pick_type
    # if user_signed_in?
    #   # qna_old = current_user.qnas.where(status: :pending).last
    # else
    #   # qna_old = Qna.find_by(auth: cookies[:tutor_qna])
    #   qna_old = Qna.new
    # end
    # if qna_old
    #   logger.info "\n\n\n #{qna_old.id}"
    #   redirect_to qna_path()
    # end
    qna_old = Qna.new
  end

  def create
    if user_signed_in? 
      puts qna_params
      @qna = current_user.qnas.create(qna_params)
      puts @qna.id
    else
      @qna = Qna.create(qna_params)
    end

    Chat.create(qna_id: @qna.id)
    
    unless user_signed_in?
      cookies[:tutor_qna] = @qna.auth
    end

    tutors = Tutor.all
    tutors.each do |tutor|
      QnaJob.set(wait: 2.seconds).perform_later("new_qna", tutor, @qna)
    end

    tutor = Tutor.first
    
    if @qna.user.present?
      QnaJob.set(wait: 2.seconds).perform_later("booked_order", tutor, @qna)
    end

    redirect_to qna_path(@qna.id)
  end

  def show 
    @qna = Qna.find(params[:id])
    @message = Message.new
  end

  def finish
    @qna = Qna.find(params[:qna_id])
    message = Message.create(content: "Client has finished the question", chat_id: @qna.chat.id)
    SendMessageJob.perform_now(message, "Finish", message.chat_id)
    @qna.update(status: "done", auth: "finish")
    redirect_to root_path
  end

  def cancel
    @qna = Qna.find(params[:qna_id])
    @qna.update(status: "cancelled", auth: "finish")
    redirect_to root_path
  end

  private

  def qna_params
    type = QnaType.find_by(name: params[:qna][:qna_type])
    
    params.require(:qna).permit(:question, :subject, :document_attachments => []).merge(qna_type_id: type.id)
  end
end
