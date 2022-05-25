class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :update_allowed_parameters, if: :devise_controller?

  protected

  def update_allowed_parameters
    devise_parameter_sanitizer.permit(:sign_in) do |u|
      u.permit(:username, :password)
    end
    devise_parameter_sanitizer.permit(:sign_up) do |u|
      u.permit(:email, :first_name, :last_name, :phone, :password, :password_confirmation)
    end
    devise_parameter_sanitizer.permit(:account_update) do |u|
      u.permit(:first_name, :last_name, :phone, :email, :password, :current_password)
    end
  end
end
