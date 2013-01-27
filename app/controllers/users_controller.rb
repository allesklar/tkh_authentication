class UsersController < ApplicationController
  
  before_filter :authenticate, only: 'index'
  before_filter :authenticate_with_admin, except: ['new', 'create']
  
  def index
    @users = User.by_recent
    render layout: 'admin'
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    set_target_page
    if @user.save
      cookies[:auth_token] = @user.auth_token # logging in the user
      redirect_to session[:target_page] || safe_root_url, notice: t('authentication.signup_confirmation')
      session[:target_page] = nil
    else
      render "new"
    end
  end
  
  def make_admin
    user = User.find(params[:id])
    user.admin = true
    user.save
    redirect_to users_path, notice: t('authentication.admin_enabled_confirmation')
  end
  
  def remove_admin
    user = User.find(params[:id])
    user.admin = false
    user.save
    redirect_to users_path, notice: t('authentication.admin_disabled_confirmation')
  end
  
  private
  
  def set_target_page
    session[:target_page] = request.referer unless session[:target_page] # && !request.referer.nil?
  end
  
end
