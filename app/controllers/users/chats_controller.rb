class Users::ChatsController < ApplicationController
  before_action :authenticate_user!
  
  def show
  end

  def destroy
  end
end
