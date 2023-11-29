class Users::UserAppController < ApplicationController
  # before_action :set_theme

  # def set_theme
  #   # logger.info "\n \n #{current_user.theme} \n \n #{params[:theme]} \n \n"
  #   if user_signed_in?
  #     if params[:theme].present?
  #       current_user.update(theme: params[:theme])
  #       theme = params[:theme].to_sym

  #       cookies[:theme] = theme
  #       redirect_to(request.referer || root_path)
  #     else
  #       theme = current_user.theme.to_sym

  #       cookies[:theme] = theme
  #     end
  #   else
  #     cookies[:theme] = "light"
  #   end
  # end
end