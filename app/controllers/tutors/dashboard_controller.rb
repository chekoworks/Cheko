class Tutors::DashboardController < ApplicationController
  before_action :authenticate_tutor!
  
  def home
  end
end
