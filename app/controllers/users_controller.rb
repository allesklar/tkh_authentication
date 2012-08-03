class UsersController < ApplicationController
  
  before_filter :authenticate, only: 'index'
  before_filter :authenticate_with_admin, only: 'index'
  
  def index
    @users = User.by_recent
    render layout: 'admin'
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      cookies[:auth_token] = @user.auth_token
      redirect_to session[:target_page] || safe_root_url, notice: t('authentication.signup_confirmation')
      session[:target_page] = nil
    else
      render "new"
    end
  end
  
end
