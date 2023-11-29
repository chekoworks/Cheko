class Tutors::QnasController < ApplicationController
  before_action :authenticate_tutor!

  def index
    @pending = Qna.where(status: "pending")
    @assigned = Qna.where(tutor_id: current_tutor.id, status: "assigned")
    @history = Qna.where(tutor_id: current_tutor.id, status: "done")
  end

  def assign
    @qna = Qna.find(params[:qna_id])
    @qna.update(tutor_id: current_tutor.id, status: "assigned")
    # Chat.create(qna_id: @qna.id)

    message = Message.create(content: "A Tutor has accepted your question, please refresh the page to start chatting", chat_id: @qna.chat.id)
    SendMessageJob.perform_now(message, "Accept", message.chat_id)

    if @qna.user.present?
      tutor = current_tutor
      QnaJob.set(wait: 2.seconds).perform_later("notify_user",tutor,@qna)
    end

    redirect_to tutors_qna_path(@qna)
  end

  def cancel
    @qna = Qna.find(params[:qna_id])
    @qna.update(tutor_id: nil, status: "pending")
    message = current_tutor.messages.create(content: "Tutor has cancelled, please refresh the page to wait for a new Tutor", chat_id: @qna.chat.id)
    SendMessageJob.perform_now(message, "Cancel", message.chat_id)
    redirect_to tutors_qnas_path
  end

  def show
    @qna = Qna.find(params[:id])
    @message = Message.new
  end

  def add_payment
    @qna = Qna.find(params[:qna_id])
    if params[:qna][:date_paid].blank?
      date_paid = DateTime.now
    else
      date_paid = DateTime.strptime(params[:qna][:date_paid], "%m/%d/%Y, %I:%M %p")
    end
    @qna.update(amount: params[:qna][:amount], date_paid: date_paid, payment_receipt: params[:qna][:payment_receipt], payment_status: 1)
    
    if @qna.valid?
      flash[:success] = "Payment Added."
    else
      flash[:alert] = "Invalid Payment Amount added"
    end
    redirect_to tutors_qna_path(params[:qna_id])
  end

end
