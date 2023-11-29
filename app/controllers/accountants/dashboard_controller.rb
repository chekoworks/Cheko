class Accountants::DashboardController < ApplicationController
  before_action :authenticate_accountant!
  
  def home
  end
end
