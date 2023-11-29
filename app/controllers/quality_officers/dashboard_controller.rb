class QualityOfficers::DashboardController < ApplicationController
  before_action :authenticate_quality_officer!
  def home
  end
end
