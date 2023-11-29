class Admins::DocumentsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @docus = Document.all
  end

  def show
    @docu = Document.find(params[:id])
  end
end
