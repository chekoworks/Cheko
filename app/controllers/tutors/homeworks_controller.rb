class Tutors::HomeworksController < ApplicationController
  before_action :authenticate_tutor!, except: [:upload]
  before_action :find_homework, except: [:index]
  
  def index
    @ongoing = Homework.where("tutor_id = ? AND status = 2", current_tutor.id).not_deleted
    @pending = Homework.where("tutor_id IS NULL AND status = 2", current_tutor.id).not_deleted
    @history = Homework.where("tutor_id = ? AND status = 3", current_tutor.id).not_deleted
    @for_admin_approval = Homework.where("tutor_id = ? AND status= 6", current_tutor.id).not_deleted
  end

  def show
    @bids = Bid.where(homework_id: @homework.id).order(ammount: :asc)
    @bid = Bid.find_by(homework_id: @homework.id, tutor_id: current_tutor.id)

    @documents = @homework.documents.where(documentable_type: "Tutor")
    @manager = @homework.documents.where(documentable_type: "Manager")
  end

  def edit
  end

  def upload
    @homework.documents.create(file: params[:document][:file], documentable_id: current_tutor.id, documentable_type: current_tutor.class.name)
    
    uploaded = @homework.documents.first.created_at.to_time
    deadline = @homework.internal_deadline.to_time
    hours = (deadline - uploaded) / 1.hours
    
    unless hours.to_i.positive?
      @homework.update(hours_late: hours)
    else
      @homework.update(hours_late: 0)
    end

    # HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "User")
    if @homework.manager.present?
      HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "NotifyTM")
      else
      HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "NotifyAdmin")
    end
    redirect_to tutors_homework_path(@homework.id)
  end

  def bid
    if @homework.bids.create(ammount: params[:ammount], tutor_id: current_tutor.id).valid?
      flash[:success] = "Bid successfully added."
      HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "TutorBid")
    else
      flash[:alert] = "Bid amount exceeded!"
    end
    redirect_to tutors_homework_path(@homework)
  end

  def edit_bid
    @bid = Bid.find_by(homework_id: @homework.id, tutor_id: current_tutor.id)
  end

  def update_bid
    @bid = Bid.find_by(homework_id: @homework.id, tutor_id: current_tutor.id)
    if @bid.update(ammount: params[:ammount])
      redirect_to tutors_homework_path(@homework)
    end
  end

  def finish_homework
    @homework.update(status: "finished_by_tutor")
    flash[:success] = "Homework successfully submitted"

    #send notification to team manager or admin
    if @homework.manager_id.present?
      HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "FinishedByTutor")
      
      HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "ForAdminApproval")
    else
      HomeworkMailerJob.set(wait: 2.seconds).perform_later(@homework, "ForAdminApproval")
    end

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
      } }, controller_action: "tutor_finish_homework"

    redirect_to tutors_homework_path(@homework.id)
  end

  private
  def find_homework
    @homework = Homework.find(params[:id] || params[:homework_id])
  end
end
