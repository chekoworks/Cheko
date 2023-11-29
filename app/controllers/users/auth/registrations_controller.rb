# frozen_string_literal: true

class Users::Auth::RegistrationsController < Devise::RegistrationsController
  # before_action :configure_sign_up_params, only: [:create]
  # before_action :configure_account_update_params, only: [:update]
  require "yaml"
  before_action :homework_params

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    # raise "Test"
    build_resource(sign_up_params)
    
    resource.save
    yield resource if block_given?
    if resource.persisted?
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        if params[:homework].present? || cookies[:homework_params].present?
          logger.info "\n\n\n #{homework_params} \n\n\n"
          admin = Admin::where(status: 1).first
          hw = resource.homeworks.create(homework_params)
          hw.update(admin_id: admin.id)

          HomeworkMailerJob.set(wait: 2.seconds).perform_later(hw, "Admin")
          HomeworkMailerJob.set(wait: 2.seconds).perform_later(hw, "NewOrder")

          HomeworkMailerJob.set(wait: 2.seconds).perform_later(hw, "BookedOrder")

          logger.info "\n\n\n IT REACHED HERE PART 1 \n\n\n"

          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          logger.info "\n\n\n IT REACHED HERE PART 2 \n\n\n"
          respond_with resource, location: new_user_session_path
        end
      else
        logger.info "\n\n\n IT REACHED HERE PART 3 \n\n\n"
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_in!
        respond_with resource, location: after_inactive_sign_up_path_for(resource)
      end
    else
      logger.info "\n\n\n IT REACHED HERE PART 4 \n\n\n"
      if params[:homework].present?
        cookies[:homework_params] = YAML::dump params[:homework]
      end
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def homework_params
    if params[:homework].present?
      deadline = DateTime.strptime(params[:homework][:deadline], "%m/%d/%Y, %I:%M %p")
      params.require(:homework).permit(:details, :payment_type, :subject, :sub_subject, :budget, :tutor_skills, :tutor_samples, :sub_type, :priority, :view_bidders, :login_school, :budget, :order_type, :words, :tutor_category).merge(deadline: deadline)
    elsif cookies[:homework_params].present?
      YAML::dump cookies[:homework_params]
    end
  end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_up_params
  #   devise_parameter_sanitizer.permit(:sign_up, keys: [:attribute])
  # end

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
