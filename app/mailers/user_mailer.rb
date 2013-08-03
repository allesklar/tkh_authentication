class UserMailer < ActionMailer::Base

  default :from => Setting.first.try(:contact_email) ? Setting.first.try(:contact_email) : 'info@tenthousandhours.eu'

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)
    @user = user
    mail :to => user.email, :subject => t('authentication.password_reset_email_subject') + ' | ' + Setting.first.try(:site_name)
  end

  def password_set(user)
    @user = user
    mail :to => user.email, :subject => t('authentication.email_validation_subject') + ' | ' + Setting.first.try(:site_name)
  end

end
