class Admins::AdminsController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_admin, except: [:index, :new, :create]

  def index
    @admins = Admin.all
  end

  def show
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)
    if @admin.save
      @admin.update!(role: 1)
      @admin.create_agent 
      redirect_to admins_admins_path, notice: "Admin successfully created"
    else
      render 'new'
    end
  end

  def edit
  end

  def update
    if @admin.update(admin_params)
      redirect_to admins_admin_path(@admin), notice: "Admin successfully updated"
    else
      render 'edit'
    end
  end

  def destroy
    @admin.destroy!
    redirect_to admins_admins_path
  end

  private
  def find_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.require(:admin).permit(:first_name, :last_name, :email, :password)
  end
end
