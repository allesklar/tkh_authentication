class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        cookies.permanent[:auth_token] = user.auth_token
      else
        cookies[:auth_token] = user.auth_token
      end
      redirect_to (session[:target_page] || (defined?(root_url) ? root_url : '/')), notice: t('authentication.login_confirmation')
      session[:target_page] = nil
    else
      flash.now.alert = t('authentication.warning.email_or_password_invalid')
      render "new"
    end
  end

  def destroy
    cookies.delete(:auth_token)
    redirect_to (defined?(root_url) ? root_url : '/'), notice: t('authentication.logout_confirmation')
  end

end
