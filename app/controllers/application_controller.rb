class ApplicationController < ActionController::Base

  private

  def current_user
    @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
  end
  helper_method :current_user

  def authenticate
    redirect_to login_url, alert: t('authentication.warning.login_needed') if current_user.nil?
  end

end
