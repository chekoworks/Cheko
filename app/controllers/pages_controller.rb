class PagesController < ApplicationController
  def home
  end

  def pick_type
  end

  def new
    @homework = Homework.new
    @user = User.new
  end

  def professors
  end

  def professor_show
    @professor = Professor.find(params[:id])
  end
end