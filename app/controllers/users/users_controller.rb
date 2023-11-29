class Users::UsersController < Users::UserAppController
  before_action :authenticate_user!
  
  def show
  end
end
