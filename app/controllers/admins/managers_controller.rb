class Admins::ManagersController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_manager, except: [:index, :new, :create]

  def index
    @managers = Manager.all
  end

  def show
    @homeworks = @manager.homeworks
  end

  def new
    @manager = Manager.new
  end

  def create
    @manager = Manager.new(manager_params)
    if @manager.save
      @manager.create_agent
      redirect_to admins_managers_path
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @manager.update(manager_params)
      redirect_to admins_manager_path(@manager)
    else
      render 'edit'
    end
  end

  def destroy
    @manager.remove_agent
    @manager.destroy!
    redirect_to admins_managers_path
  end

  private 

  def find_manager
    @manager = Manager.find(params[:id])
  end

  def manager_params
    params.require(:manager).permit(:first_name, :last_name, :email, :password)
  end
end
