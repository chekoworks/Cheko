class Admins::ProfessorsController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_prof, except: [:index, :new, :create]
  include ProfessorMetricsHelper

  def index
    @professors = Professor.all
    @pending = ProfReview.where(status: "pending")
  end

  def show
  end
  
  def new
    @professor = Professor.new
    @school = School.all
  end

  def create
    @professor = Professor.create(professor_params)

    if @professor.school_id.nil? && params[:school_name].present?
      unless School.where("LOWER(name) = LOWER(?)", params[:school_name]).first
        new_school = School.create(name: params[:school_name])
        @professor.update(school_id: new_school.id)
      end
    end

    redirect_to admins_professors_path
  end

  def edit
  end

  def update
    @professor.update(professor_params)
    redirect_to admins_professor_path(@professor)
  end

  def approve
  end

  def deny
  end

  def destroy
  end

  private

  def find_prof
    @professor = Professor.find(params[:id] || params[:professor_id])
  end

  def professor_params
    params.require(:professor).permit(:first_name, :last_name, :school_id, :easiness, :effectiveness, :life_changing, :light_workload, :leniency, :average, :a_able, :b_pls_able, :b_able, :c_able, :batch1_able, :batch2_able, :batch3_able, :batch4_able, :our_comments, :additional_metric_grade)
  end
end
