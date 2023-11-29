class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_theme

  private
  def set_theme
    # logger.info "\n \n #{current_user.theme} \n \n #{params[:theme]} \n \n"
    if user_signed_in?
      if params[:theme].present?
        current_user.update(theme: params[:theme])
        theme = params[:theme].to_sym

        cookies[:theme] = theme
        logger.info "\n \n #{current_user.theme} \n \n #{params[:theme]} \n \n #{URI(request.referer).path} \n \n"
        # redirect_back(fallback_location: URI(request.referer).path)
      else
        theme = current_user.theme.to_sym

        cookies[:theme] = theme
      end
    else
      cookies[:theme] = "light"
    end
  end

  def after_sign_in_path_for(resource)
    if resource.class == Admin
      stored_location_for(resource) || admins_homeworks_path
    elsif resource.class == Manager
      stored_location_for(resource) || managers_homeworks_path
    elsif resource.class == Tutor
      stored_location_for(resource) || tutors_homeworks_path
    elsif resource.class == User
      stored_location_for(resource) || users_path
    elsif resource.class == Accountant
      stored_location_for(resource) || accountants_homeworks_path
    elsif resource.class == QualityOfficer
      stored_location_for(resource) || quality_officers_homeworks_path
    else
      root_path
    end
  end

  def after_sign_out_path_for(resource)
    if resource == :admin
      new_admin_session_path
    elsif resource == :user
      new_user_session_path
    elsif resource == :manager
      new_manager_session_path
    elsif resource == :tutor
      new_tutor_session_path
    else
      root_path
    end
  end

  def authenticate_admin!
    if admin_signed_in?
      super
    else
      redirect_to new_admin_session_path, :alert => 'You must login to continue'
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :school, :birthday, :school, :course, :year, :college, :address, :phone_number])
  end
end
