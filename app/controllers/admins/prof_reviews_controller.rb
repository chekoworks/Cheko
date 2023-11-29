class Admins::ProfReviewsController < ApplicationController
  before_action :authenticate_admin!

  def show
    @professor = ProfReview.find(params[:id])
  end

  def update
  end

  def approve
    @prof_review = ProfReview.find(params[:prof_review_id])
    if params[:prof_id].present?
      @prof_review.update(status: "approved", professor_id: params[:prof_id])
      Professor.find(params[:prof_id]).update_grading
      redirect_to admins_professor_path(params[:prof_id])
    else
      hash = JSON.parse(@prof_review.to_json)
      hash = hash.except("id", "professor_id", "user_id", "created_at", "updated_at", "status", "content", "school", "school_name")
      new_prof = Professor.create(hash)
      new_prof.update(subject: params[:subject], our_comments: params[:our_comment])
      @prof_review.update(status: "approved", professor_id: new_prof)

      if @prof_review.school_id.nil? && @prof_review.school_name.present?
        unless School.where("LOWER(name) = LOWER(?)", @prof_review.school).first
          new_school = School.create(name: @prof_review.school_name)
          new_prof.update(school_id: new_school.id)
        end
      end

      if @prof_review.school_id.present?
        new_prof.set_up_email
      end

      redirect_to admins_professor_path(new_prof.id)
    end
  end
end
