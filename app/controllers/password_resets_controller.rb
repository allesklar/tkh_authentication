class PasswordResetsController < ApplicationController

  def create
    user = User.find_by_email(params[:email])
    if user
      user.send_password_reset
      redirect_to root_url, :notice => t('authentication.reset_password_email_sent_confirmation')
    else
      redirect_to root_url, :alert => t('authentication.warning.no_such_email')
    end
  end

  def edit
    @user = User.find_by_password_reset_token!(params[:id])
  end

  def update
    @user = User.find_by_password_reset_token!(params[:id])
    if @user.password_reset_sent_at < 2.hours.ago
      redirect_to new_password_reset_path, :alert => t('authentication.warning.password_reset_expired')
    elsif @user.update_attributes(params[:user])
      cookies[:auth_token] = @user.auth_token # logging in the user
      redirect_to session[:target_page] || safe_root_url, notice: t('authentication.password_reset_confirmation')
    else
      render :edit
    end
  end

end
