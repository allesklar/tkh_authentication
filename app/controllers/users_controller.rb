class UsersController < ApplicationController

  before_filter :authenticate, only: 'index'
  before_filter :authenticate_with_admin, except: ['new', 'create', 'detect_existence']

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

  def detect_existence
    set_target_page
    user = User.where('email = ?', params[:user][:email]).first
    if user && !user.password_digest.blank? && user.password != 'temporary'
      flash[:notice] = "Our records show you have an account with us. Please login."
      redirect_to login_path
    else
      if user
        newbie = Newbie.where('email = ?', params[:user][:email]).first
      else
        newbie = Newbie.create(email: params[:user][:email])
      end
      newbie.send_password_set
      flash[:notice] = "Our records show you do not have an account with us. We need to verify your email address. Please check your email inbox (or spam filter if you have nothing after several minutes) and click on the confirmation link."
      redirect_to safe_root_url
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
