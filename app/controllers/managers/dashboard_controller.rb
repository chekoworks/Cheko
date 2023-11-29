class Managers::DashboardController < ApplicationController
  before_action :authenticate_manager!
  
  def home
  end
end
