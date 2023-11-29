class Admins::TutorsController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_tutor, except: [:index, :new, :create]

  def index
    @tutors = Tutor.all
  end

  def show
    @ongoing = Homework.where("tutor_id = ? AND status = 2", @tutor.id)
    @history = Homework.where("tutor_id = ? AND status = 3", @tutor.id)
  end

  def new
    @tutor = Tutor.new
  end

  def create
    @tutor = Tutor.new(tutor_params)
    if @tutor.save
      @tutor.update!(status: 1)
      redirect_to admins_tutors_path, notice: "Tutor successfully created"
    else
      flash.now[:alert] = "Email is already been used"
      render 'new'
    end
  end

  def edit
  end

  def update
    if @tutor.update(tutor_params)
      redirect_to admins_tutor_path(@tutor), notice: "Tutor successfully updated"
    else
      render 'edit'
    end
  end

  def destroy
    
    Homework.where(tutor_id: @tutor.id).each do |hmw|
      hmw.update(tutor_id: nil)
    end
    
    @tutor.destroy!
    redirect_to admins_tutors_path, notice: "Tutor successfully deleted"
  end

  private 

  def find_tutor
    @tutor = Tutor.find(params[:id])
  end

  def tutor_params
    params.require(:tutor).permit(:first_name, :last_name, :email, :password)
  end
end
