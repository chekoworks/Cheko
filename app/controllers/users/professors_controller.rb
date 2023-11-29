class Users::ProfessorsController < Users::UserAppController
  before_action :authenticate_user!, except: [:search]
  include ProfessorMetricsHelper
  
  def index
  end

  def show
    @professor = Professor.find(params[:id])
    @reviews = @professor.prof_reviews.where(status: "approved")
  end

  def new
    @professor = params[:prof_id].present? ? Professor.find(params[:prof_id]) : nil
    @prof_review = ProfReview.new
    @school = School.all
  end

  def create 
    # raise "test"
    @prof_review = current_user.prof_reviews.create(professor_params)
    prof = Professor.find_by(first_name: @prof_review.first_name, last_name: @prof_review.last_name)
    if prof
      @prof_review.update(status: "approved", professor_id: prof.id)
      prof.update_grading
      redirect_to users_professors_path
    elsif params[:prof_id].present?
      @professor = current_user.prof_reviews.create(professor_params)
      @professor.update(status: "approved")
      redirect_to users_professors_path
    else
      hash = JSON.parse(@prof_review.to_json)
      hash = hash.except("id", "professor_id", "user_id", "created_at", "updated_at", "status", "content", "school", "school_name")
      new_prof = Professor.create(hash)
      new_prof.update(subject: params[:prof_review][:subject])
      @prof_review.update(status: "approved", professor_id: new_prof)

      if @prof_review.school_id.nil? || @prof_review.school_id == 0 && @prof_review.school_name.present?
        unless School.where("LOWER(name) = LOWER(?)", @prof_review.school).first
          new_school = School.create(name: @prof_review.school_name)
          new_prof.update(school_id: new_school.id)
        end
      end

      if @prof_review.school_id.present?
        new_prof.set_up_email
      end

      if current_user.present?
        user = current_user
        ProfToPickJob.set(wait: 2.seconds).perform_later("review_recieved", user)
      end
      
      redirect_to users_professors_path
    end

    
  end

  def search
    # profs = Professor.all()
    profs = Professor.where("LOWER(first_name) LIKE :search OR LOWER(last_name) LIKE :search", {search: "%#{params[:search].downcase}%"}).map{|prof| [prof.name, prof.id]}
    #.pluck(:first_name, :last_name)
    render json: {profs: profs}
  end

  private
  def professor_params
    params.require(:prof_review).permit(:first_name, :last_name, :school_id, :school_name, :easiness, :effectiveness, :life_changing, :light_workload, :leniency, :average, :a_able, :b_pls_able, :b_able, :c_able, :batch1_able, :batch2_able, :batch3_able, :batch4_able, :content, :subject, :additional_metric_grade, :professor_id)
  end
end
