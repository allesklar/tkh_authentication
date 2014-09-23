class ReceptionController < ApplicationController

  # TODO change email address - may be a profile feature in tkh_mailing_list
  # TODO change password -              ""
  # TODO localize the whole process

  before_action :set_target_page, only: [ :email_input, :parse_email, :email_validation, :create_your_password, :enter_your_password, :disconnect ]

  def email_input
  end

  def parse_email
    unless params[:user][:email].blank?
      @user = User.find_by(email: params[:user][:email])
      if @user.blank? # first take care of the easy case with a completely new user
        # create new record
        @user = User.new(user_params)
        if @user.save
          send_validation_email
          @status = 'email_validation'
          respond_to do |format|
            format.html { flash[:notice] = "Your record has been successfully created." }
            format.js {}
          end
        else # problem saving new user record for some reason
          @status = 'no_user_save'
          respond_to do |format|
            format.html { flash[:alert] = "We had problems creating your record. Please try again. Make sure the email address is valid." }
            format.js {}
          end
        end
      else # the email address was already in the database
        # Returning user pathway goes here
        if @user.email_validated? && @user.has_a_password?
          @status = 'enter_password'
          respond_to do |format|
            format.html { redirect_to enter_your_password_path(auth_token: @user.auth_token) }
            format.js {}
          end
        elsif @user.email_validated? && !@user.has_a_password? # doesn't have a password
          # User needs to securily create a password
          send_password_creation_security_email
          # show screen to user with notice about password confirmation email
          @status = 'password_confirmation'
          respond_to do |format|
            format.html { flash[:notice] = "There is 1 last step!" }
            format.js {}
          end
        elsif !@user.email_validated?
          send_validation_email
          # show screen to user with notice about email validation
          @status = 'email_validation'
          respond_to do |format|
            format.html { flash[:notice] = "For your security, we need to verify your email address." }
            format.js {}
          end
        end
      end
    else # email is blank
      @status = 'blank_email'
      respond_to do |format|
        format.html { flash[:alert] = "Your email address cannot be blank." }
        format.js {}
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
    @user = User.find(params[:id])
    unless @user.blank?
      if !params[:user][:password].blank? && (params[:user][:password] == params[:user][:password_confirmation])
        if @user.password_creation_token_sent_at >= Time.zone.now - 1.hour # still valid token
          if @user.update(user_params)
            login_the_user
            flash[:notice] = "Your new password was created and you have been logged in."
            redirect_to session[:target_page] || root_path
            destroy_target_page
          else # did not update ?!?
            flash[:alert] = "Some problems occurred while trying to create your password"
            render create_your_password
          end
        else # the token has expired
          redirect_to email_input_path, alert: 'Sorry, your password_creation_token has expired. To protect your privacy and ensure your security, we need to ask you to start the process over again. The token, when created, expires after 1 hour!'
        end
      else # password is blank or password and password_confirmation don't match
         redirect_to ( request.env["HTTP_REFERER"].present? ? :back : root_path ), alert: 'Your password cannot be blank and the password should be identical to the password confirmation. Please try again.'
      end
    else # @user is blank
      redirect_to email_input_path, alert: 'We could not find this user record in our database. Please start the process over.'
    end
  end

  def enter_your_password
    @user = User.find_by(auth_token: params[:auth_token])
  end

  def password_checking
    @user = User.find(params[:id])
    if @user
      if @user.email_validated?
        if @user.authenticate(params[:user][:password])
          login_the_user
          flash[:notice] = t('authentication.login_confirmation')
          redirect_user_upon_successful_login
          destroy_target_page
        else # most likely wrong password
          flash.now.alert = t('authentication.warning.email_or_password_invalid')
          render "enter_your_password"
        end
      else # email not validated
        send_validation_email
        redirect_to root_path, alert: 'Our records show that your email address has not been validated. We need you to do so before letting your log in. Please check your email inbox or spam folder for an validation email.'
      end
    else # we can't find the user in the database
      flash[:alert] = "We were unable to find your email in the database. Please try again and make sure you are using a valid email address."
      redirect_to email_input_url
    end
  end

  def i_forgot_my_password
  end

  def request_new_password
    @user = User.find_by(email: params[:user][:email])
    if @user
      send_new_password_request_email
      # show confirmation screen
    else
      redirect_to i_forgot_my_password_path, alert: "We could not find a user with this email address: #{params[:user][:email]}. Please try again."
    end
  end

  def change_your_password
    @user = User.find_by(password_reset_token: params[:password_reset_token])
    if @user.blank?
      redirect_to email_input_url, alert: "We were unable to find the record in the database. Please restart the process and make sure you are using a valid email address."
    end
  end

  def password_reset
    @user = User.find(params[:id])
    if @user.present?
      if params[:user][:password].present? && (params[:user][:password] == params[:user][:password_confirmation])
        if @user.password_reset_sent_at >= Time.zone.now - 1.hour # still valid token
          if @user.update(user_params)
            login_the_user
            flash[:notice] = "Your password was changed and you have been logged in."
            redirect_to session[:target_page] || root_path
            destroy_target_page
          else # did not update ?!?
            flash[:alert] = "Some problems occurred while trying to change your password. Please try again."
            render change_your_password
          end
        else # the token has expired
          redirect_to email_input_path, alert: 'Sorry, your password_reset_token has expired. To protect your privacy and ensure your security, we need to ask you to start the process over again. The token, when created, expires after 1 hour!'
        end
      else # password is blank or password and password_confirmation don't match
        redirect_to :back, alert: 'Your password cannot be blank and the password should be identical to the password confirmation. Please try again.'
      end
    else # @user is blank
      redirect_to email_input_path, alert: 'We could not find this user record in our database. Please start the process over.'
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

  def send_new_password_request_email
    set_password_reset_token
    ReceptionMailer.new_password_request_email(@user).deliver
  end

  def set_password_reset_token
    @user.generate_token(:password_reset_token)
    @user.password_reset_sent_at = Time.zone.now
    @user.save
  end

  def login_the_user
    if params[:user][:remember_me].to_i == 1
      cookies.permanent[:auth_token] = @user.auth_token
    else
      cookies[:auth_token] = @user.auth_token
    end
  end

  def redirect_user_upon_successful_login
    if session[:target_page].present?
      # add case when target pages is login page.
      unless Rails.application.routes.recognize_path(session[:target_page])[:controller] == 'reception'
        redirect_to session[:target_page]
      else # the target page is the login or reception page
        redirect_to root_url
      end
    else # no target page is set
      redirect_to root_url
    end
  end

end
