class UsersController < ApplicationController

  before_filter :authenticate, only: 'index'
  before_filter :authenticate_with_admin, except: ['new', 'create', 'detect_existence', 'get_names', 'save_names_and_validate_email']

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
      destroy_target_page
    else
      render "new"
    end
  end

  def detect_existence
    set_target_page
    @detected_email = params[:user][:email]
    user = User.where('email = ?', @detected_email).first
    if user && !user.password_digest.blank? && user.password != 'temporary'
      flash[:notice] = "Our records show you have an account with us. Please login."
      redirect_to login_path(email: @detected_email)
    else
      if user # there is a mailing list record but user never created a password account
        user = User.where('email = ?', params[:user][:email]).first
        if user.first_name.blank? || user.last_name.blank?
          get_names_from_user(user)
        else
          verify_email_address(user)
        end
      else # there are no records at all
        user = User.new(email: params[:user][:email])
        user.password, user.password_confirmation = 'temporary', 'temporary'
        user.save!
        get_names_from_user(user)
      end
    end
  end

  def get_names
    @user = User.find(params[:id])
    flash[:notice] = "Please enter your name."
  end

  def save_names_and_validate_email
    @user = User.find(params[:id])
    @user.update_attributes(params[:user])
    verify_email_address(@user)
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

  def destroy_target_page
    session[:target_page] = nil
  end

  def verify_email_address(user)
    user = User.find(user.id)
    user.send_password_set
    flash[:notice] = "We need to verify your email address. Please check your email inbox (or spam filter if you have nothing after several minutes) and click on the confirmation link."
    redirect_to safe_root_url
  end

  def get_names_from_user(user)
    user = User.find(user.id)
    redirect_to get_names_user_path(user)
  end

end
