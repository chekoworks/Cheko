class PagesController < ApplicationController
  def home
  end

  def pick_type
  end

  def new
    @homework = Homework.new
    @user = User.new
  end

  def contact_us
    @contact = Contact.new
  end

  def check_email
    check = User.find_by(email: params[:user][:email])
    render :plain => check.nil?
  end

  def professor_show
    @professor = Professor.find(params[:id])
    @reviews = @professor.prof_reviews.where(status: "approved")
  end

  def how_it_works
  end

  def pricing
  end
end
