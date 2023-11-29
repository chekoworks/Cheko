class Admins::UsersController < ApplicationController
  before_action :authenticate_admin!
  before_action :find_user, except: [:index, :new, :create]

  def index
    @users = User.all
  end

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admins_user_path(@user), notice: "User successfully updated"
    else
      render 'edit'
    end
  end

  def destroy
    @user.destroy!
    redirect_to admins_users_path, notice: "User successfully deleted"
  end

  private

  def find_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
