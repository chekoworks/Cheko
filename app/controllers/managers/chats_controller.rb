class Managers::ChatsController < ApplicationController
  before_action :authenticate_manager!
  
  def index
  end
end
