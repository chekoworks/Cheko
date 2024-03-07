# frozen_string_literal: true

class Users::Auth::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  def new
    super
  end

  # POST /resource/sign_in
  def create
    super

    Analytics.identify(
      user_id: current_user.id,
      traits: {
        email: current_user.email,
        name: current_user.name
      }
    )

    Analytics.track(
      user_id: current_user.id,
      event: 'Signed In'
    )
  end

  # DELETE /resource/sign_out
  def destroy
    cookies[:theme] = ""
    cookies[:tutor_qna] = ""
    super
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
