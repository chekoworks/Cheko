class Admins::DashboardController < ApplicationController
  before_action :authenticate_admin!
  
  def home
    redirect_to admins_homeworks_path
  end
end
