class Admins::AccountantsController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_accountant, except: [:index, :new, :create]

  def index
    @accountants = Accountant.all
  end

  def show
  end

  def new
    @accountant = Accountant.new
  end

  def create
    @accountant = Accountant.new(accountant_params)
    if @accountant.save
      redirect_to admins_accountants_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @accountant.update(accountant_params)
      redirect_to admins_accountant_path(@accountant)
    else
      render 'edit'
    end
  end

  def destroy
    @accountant.destroy!
    redirect_to admins_accountants_path
  end

  private
  def find_accountant
    @accountant = Accountant.find(params[:id])
  end

  def accountant_params
    params.require(:accountant).permit(:first_name, :last_name, :email, :password)
  end
end
