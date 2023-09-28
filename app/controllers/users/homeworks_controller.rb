class Users::HomeworksController < Users::UserAppController
  before_action :authenticate_user!
  before_action :find_homework, except: [:index, :create, :new, :pick_type, :add_to_drafts]
  
  def index
    # @pending = current_user.homeworks.where(status: "reviewing")
    # @ongoing = current_user.homeworks.where(status: "ongoing")
    # @history = current_user.homeworks.where(status: "done")
    @homeworks = current_user.homeworks.not_deleted
  end

  def show
    @tutor = @homework.documents.where(documentable_type: "Tutor")
    @qco = @homework.documents.where(documentable_type: "QualityOfficer")
    @admin = @homework.documents.where(documentable_type: "Admin")
    @manager = @homework.documents.where(documentable_type: "Manager")
  end

  def new
    if params[:type].blank?
      redirect_to pick_type_users_homeworks_path
    else
      @homework = current_user.homeworks.new()
    end
  end

  def create
    @admin = Admin::where(role: 1, status: 1).first
    @homework = current_user.homeworks.new(homework_params)

    if @homework.save
      #assign admin_id
      @homework.update(admin_id: @admin.id)

      HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "NewOrder")
      # HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "Admin")

      # team_managers = Manager.all
      # team_managers.each do |team_manager|
      #   NotifyTmMailerJob.set(wait: 2.seconds).perform_later("new_order", team_manager)
      # end

      HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "BookedOrder")

      ActionCable.server.broadcast 'homework_update_channel', data: { homework: {
          id: @homework.id, 
          created_at: @homework.created_at.strftime("%b %d, %Y"), order_type: @homework.order_type.titleize, 
          sub_type: @homework.sub_type.present? ? @homework.sub_type.titleize : "", 
          deadline: @homework.deadline.present? ? @homework.deadline.strftime("%b %d, %Y - %l:%M %p"): "",  
          subject: @homework.subject.present? ? @homework.subject.titleize : "",
          tutor_category: @homework.tutor_category.present? ? @homework.tutor_category.titleize : "",
          words: @homework.words.present? ? @homework.words : "",
          tutor_samples: @homework.tutor_samples.present? ? @homework.tutor_samples.to_s.capitalize : "",
          tutor_skills: @homework.tutor_skills.present? ? @homework.tutor_skills.to_s.capitalize : "",
          view_bidders: @homework.view_bidders.present? ? @homework.view_bidders.to_s.capitalize : "",
          priority: @homework.priority.present? ? @homework.priority.to_s.capitalize : "",
          login_school: @homework.login_school.present? ? @homework.login_school.to_s.capitalize : "",
          admin_id: @homework.admin_id,
          admin: @homework.admin.name,
          name: @homework.name.present? ? @homework.name : "",
          order_type: @homework.order_type.titleize,
          internal_deadline_date: @homework.internal_deadline.present? ? @homework.internal_deadline.strftime("%B %d, %Y") : "",
          internal_deadline_time: @homework.internal_deadline.present? ? @homework.internal_deadline.strftime("%l:%M %p") : "",
          details: @homework.details.present? ? @homework.details : "",
          user: @homework.user.present? ? @homework.user.name : "",
          tutor: @homework.tutor.present? ? @homework.tutor.name : "",
          sub_tutor: @homework.sub_tutor.present? ? @homework.sub_tutor.name : "",
          hours_late: @homework.hours_late.present? ? @homework.hours_late : "",
          prof: @homework.prof.present? ? @homework.prof : "",
          grade: @homework.grade.present? ? @homework.grade : "",
          status: @homework.status.present? ? @homework.status : "",
          manager: @homework.manager.present? ? @homework.manager.name : "",
          tutor_price: @homework.tutor_price.present? ? @homework.tutor_price : "",
          price: @homework.price.present? ? @homework.price : "",
          profit: @homework.profit.present? ? @homework.profit : "",
          updates: @homework.updates.present? ? @homework.updates : "",
          sub_subject: @homework.sub_subject.present? ? @homework.sub_subject : "",
          file_received: @homework.file_received.present? ? @homework.file_received : "",
          notes: @homework.notes.present? ? @homework.notes : "",
          course: @homework.user.present? ? @homework.user.course : "",
          payment_received: @homework.payment_received.present? ? @homework.payment_received : "",
          } },
      controller_action: "create"

      redirect_to users_homework_path(@homework.id), :alert => "Thanks for your order! Kindly message us through our chatbox on the lower right corner to confirm the price!"
    else
      render 'new'
    end
  end

  def success
    unless @homework.user_id == current_user.id
      redirect_to users_homeworks_path
    end
  end

  def edit
  end

  def update
    if @homework.update!(homework_params)
      redirect_to users_homeworks_path
    else
      render 'edit'
    end
  end

  def destroy
  end

  def add_to_drafts
    @homework = current_user.homeworks.new(homework_params)
    if @homework.save
      @homework.update(status: "in_draft")
      redirect_to users_homeworks_path
    else
      redirect_to new_users_homework_path
    end
  end

  def submit_homework
    @admin = Admin::where(role: 1, status: 1).first
    @homework = Homework.update(@homework.id, status: "reviewing", admin_id: @admin.id)

    HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "NewOrder")
    #send email all tutors that new homework is up for bidding
  
    HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "BookedOrder")

    redirect_to users_homeworks_path
  end

  def delete_draft
    @homework = Homework.find(params[:homework_id])
    @homework.soft_delete
    @homework.update(status: "deleted", deleted_at: DateTime.now)
    redirect_to users_homeworks_path
  end

  private 

  def find_homework
    @homework = Homework.find(params[:id] || params[:homework_id])
  end

  def homework_params
    if params[:homework][:deadline].blank?
      deadline = DateTime.now
    else
      deadline = DateTime.strptime(params[:homework][:deadline], "%m/%d/%Y, %I:%M %p")
    end
    params.require(:homework).permit(:details, :payment_type, :subject, :sub_subject, :budget, :tutor_skills, :tutor_samples, :sub_type, :priority, :view_bidders, :login_school, :budget, :order_type, :words, :tutor_category, :hw_attachment => []).merge(deadline: deadline)
  end
end
