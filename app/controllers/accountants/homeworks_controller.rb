class Accountants::HomeworksController < ApplicationController
  before_action :authenticate_accountant!
  before_action :find_homework, except: [:index]
  
  def index
    @pending = Homework.where(payment_status: "unpaid").order(created_at: :desc)
    @history = Homework.where(payment_status: "paid").order(created_at: :desc)
  end

  def update
    @homework.approve_payment
    redirect_to accountants_homeworks_path
  end

  private 

  def find_homework
    @homework = Homework.find(params[:id] || params[:homework_id])
  end
end
