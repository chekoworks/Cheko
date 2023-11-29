class QualityOfficers::HomeworksController < ApplicationController
  before_action :authenticate_quality_officer!
  before_action :find_homework, except: [:index]

  def index
    @history = Homework.where(status: "done").order(created_at: :asc)
    @ongoing = Homework.where(status: "ongoing")
  end

  def show
    @tutor = @homework.documents.where(documentable_type: "Tutor")
    @qco = @homework.documents.where(documentable_type: "QualityOfficer")
  end

  def upload
    @homework.documents.create(file: params[:document][:file], documentable_id: current_quality_officer.id, documentable_type: current_quality_officer.class.name)
    redirect_to quality_officers_homework_path(@homework.id)
  end

  private
  def find_homework
    @homework = Homework.find(params[:id] || params[:homework_id])
  end
end
