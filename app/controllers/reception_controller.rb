class ReceptionController < ApplicationController

  # TODO in logging in. remember me box in forms
  # TODO login security for email non-validated and nil password
  # TODO Add forgot your password link
  # TODO password reset
  # TODO wanna log in w. different email?

  # TODO Ajaxify everything.

  # Add name fields in login forms whenever they are all blank

  # TODO change email address - may be a profile feature in tkh_mailing_list
  # TODO localize the whole process

  before_action :set_target_page, only: [ :email_input, :parse_email, :email_validation, :create_your_password, :enter_your_password, :disconnect ]

  def email_input
  end

  def parse_email
    @user = User.find_by(email: params[:user][:email])

    if @user.blank? # first take care of the easy case with a completely new user
      # create new record
      @user = User.new(user_params)
      if @user.save
        send_validation_email
        flash[:notice] = "Your record has been successfully created."
        # show screen to user with notice about email validation
        @status = 'email_validation_email_sent'
      else # problem saving new user record for some reason
        redirect_to email_input_path, alert: "We had problems creating your record. Please try again. Make sure the email address is valid."
      end

    else # the email address was already in the database
      # Returning user pathway goes here
      if @user.email_validated? && @user.has_a_password?
        # flash[:notice] = "Please enter your password" # redundent
        redirect_to enter_your_password_path(auth_token: @user.auth_token)
      elsif @user.email_validated? && !@user.has_a_password? # doesn't have a password
        # User needs to securily create a password
        send_password_creation_security_email
        flash[:notice] = "There is 1 last step!"
        # show screen to user with notice about password confirmation email
        @status = 'password_confirmation_email_sent'
      elsif !@user.email_validated?
        send_validation_email
        flash[:notice] = "For your security, we need to verify your email address."
        # show screen to user with notice about email validation
        @status = 'email_validation_email_sent'
      end
    end
  end

  def email_validation
    @user = User.where(email_validation_token: params[:token]).first
    if @user && @user.email_validation_token_sent_at >= Time.zone.now - 1.hour # still valid token
      @user.email_validated = true
      @user.save
      unless @user.has_a_password?
        set_password_creation_token
        flash[:notice] = "Your email has been validated. There is 1 last step!"
        redirect_to create_your_password_path(password_creation_token: @user.password_creation_token)
      else # the user has a password
        redirect_to enter_your_password_path(auth_token: @user.auth_token)
      end
    elsif @user && @user.email_validation_token_sent_at <= Time.zone.now - 1.hour # expiredd token
      redirect_to email_input_url, alert: "Your verification token was created over an hour ago. Please restart the process."
    else
      redirect_to email_input_url, alert: "We were unable to validate your email. Please try again and make sure you are using a valid email address."
    end
  end

  def create_your_password
    @user = User.find_by(password_creation_token: params[:password_creation_token])
    if @user.blank?
      redirect_to email_input_url, alert: "We were unable to find the record in the database. Please restart the process and make sure you are using a valid email address."
    end
  end

  def password_creation
    @user = User.find(params[:id]) # FIXME Is this secure. Should we find user by password_creation_token ?
    if params[:user][:password] == params[:user][:password_confirmation]

      # TODO check for expiration of password_creation_token

      # TODO security for email non-validated and nil password

      if @user.update(user_params)
        login_the_user
        flash[:notice] = "Your new password was created and you have been logged in."
        redirect_to session[:target_page] || root_path
        destroy_target_page
      else
        flash[:alert] = "Some problems occurred while trying to create your password"
        render create_your_password
      end
    else # password and password_confirmation don't match
      redirect_to :back, alert: 'Password and password confirmation values must match'
    end
  end

  def enter_your_password
    @user = User.find_by(auth_token: params[:auth_token])
  end

  def password_checking
    # TODO security for email non-validated and nil password
    @user = User.find(params[:id])
    if @user
      if @user.authenticate(params[:user][:password])
        login_the_user
        redirect_to (session[:target_page] || root_url), notice: t('authentication.login_confirmation')
        destroy_target_page
      else # most linkely wrong password
        flash.now.alert = t('authentication.warning.email_or_password_invalid')
        render "enter_your_password"
      end
    else # we can't find the user in the database
      flash[:alert] = "We were unable to find your email in the database. Please try again and make sure you are using a valid email address."
      redirect_to email_input_url
    end
  end

  def disconnect
    cookies.delete(:auth_token)
    redirect_to session[:target_page] || root_url, notice: t('authentication.logout_confirmation')
    destroy_target_page
  end

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit :email, :password, :password_confirmation, :first_name, :last_name, :other_name
  end

  def set_target_page
    session[:target_page] = request.referer unless session[:target_page]
  end

  def destroy_target_page
    session[:target_page] = nil
  end

  def send_validation_email
    set_email_validation_token
    ReceptionMailer.verification_email(@user).deliver
  end

  def set_email_validation_token
    @user.generate_token(:email_validation_token)
    @user.email_validation_token_sent_at = Time.zone.now
    @user.save
  end

  def send_password_creation_security_email
    set_password_creation_token
    ReceptionMailer.password_creation_verification_email(@user).deliver
  end

  def set_password_creation_token
    @user.generate_token(:password_creation_token)
    @user.password_creation_token_sent_at = Time.zone.now
    @user.save
  end

  def login_the_user
    if params[:remember_me]
      cookies.permanent[:auth_token] = @user.auth_token
    else
      cookies[:auth_token] = @user.auth_token
    end
  end

end
