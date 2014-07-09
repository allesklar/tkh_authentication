class ReceptionController < ApplicationController

  def email_input
  end

  def parse_email
    @user = User.find_by(email: params[:user][:email])

    unless @user # first take care of the easy case with a completely new user
      # handle here the new user
      set_target_page
      # create new record
      @user = User.new(user_params)
      if @user.save
        # send validation email
        set_email_validation_token
        ReceptionMailer.verification_email(@user).deliver
        # show screen to user with notice about email validation
        flash[:notice] = "Your record has been successfully created."
      else # problem saving new user record for some reason
        # render "new"
      end

    else # the email address was already in the database
      # Returning user pathway goes here
      # redirect_to :back, notice: "Hi there #{@user.email}!"
    end
  end

  def email_validation
    @user = User.where(email_validation_token: params[:token]).first
    if @user && @user.email_validation_token_sent_at >= Time.zone.now - 1.hour
      @user.email_validated = true
      @user.save
      # below is true for some of them. make sure first they don't have one.
      # TODO users who validate later on should be redirected to password creation and login page
      if @user.password_digest.blank?
        flash[:notice] = "IN CONSTRUCTION. You will soon be redirected to the password creation page"
        redirect_to email_input_path
      else
        flash[:notice] = "IN CONSTRUCTION. You will soon be redirected to the login with password page"
        redirect_to email_input_path
      end
    elsif @user && @user.email_validation_token_sent_at <= Time.zone.now - 1.hour
      redirect_to email_input_url, alert: "Your verification token was created over an hour ago. Please restart the process."
    else
      redirect_to email_input_url, alert: "We were unable to validate your email. Please try again and make sure you are using a valid email address."
    end
  end

  private

  def set_target_page
    session[:target_page] = request.referer unless session[:target_page]
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def user_params
    params.require(:user).permit :email, :password, :password_confirmation, :first_name, :last_name, :other_name
  end

  def set_email_validation_token
    @user.email_validation_token = SecureRandom.hex(30)
    @user.email_validation_token_sent_at = Time.zone.now
    @user.save
  end

end
