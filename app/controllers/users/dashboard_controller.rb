class Users::DashboardController < Users::UserAppController
  before_action :authenticate_user!
  
  def home
  end
end
