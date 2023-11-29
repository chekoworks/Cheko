class Users::QnasController < Users::UserAppController
  before_action :authenticate_user!
  
  def index
    @qnas = current_user.qnas.where("status = 0 OR status = 1")
    @finish = current_user.qnas.where(status: "done")
  end

  def new
    @qna = current_user.qnas.new
    # if qna_old = Qna.find_by(auth: cookies[:tutor_qna])
    #   redirect_to users_qna_path(qna_old.id)
    # else
    #   @qna = current_user.qnas.new
    # end
  end

  def create
    @qna = current_user.qnas.create(qna_params)
    cookies[:tutor_qna] = @qna

    redirect_to users_path 
  end

  def show 
    @qna = Qna.find(params[:id])
    @message = Message.new
  end

  def finish
    @qna = Qna.find(params[:qna_id])
    @qna.update(status: "done")

    redirect_to users_path
  end

  def cancel
    @qna = Qna.find(params[:qna_id])
    @qna.update(status: "cancelled")

    redirect_to users_path
  end

  private

  def qna_params
    params.require(:qna).permit(:question, :subject,document_attachments: [])
  end
end
