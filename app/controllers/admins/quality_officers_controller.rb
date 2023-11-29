class Admins::QualityOfficersController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_qo, except: [:index, :new, :create]

  def index
    @officers = QualityOfficer.all
  end

  def show
  end

  def new
    @officer = QualityOfficer.new
  end

  def create
    if QualityOfficer.create(qo_params)
      redirect_to admins_quality_officers_path
    else
      render 'edit'
    end
  end

  def edit
  end

  def update
  end

  private
  def qo_params
    params.require(:quality_officer).permit(:first_name, :last_name, :email, :password)
  end

  def find_qo
    @officer = QualityOfficer.find(params[:id])
  end
end
