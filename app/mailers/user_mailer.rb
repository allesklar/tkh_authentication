class UserMailer < ActionMailer::Base
  
  if defined?(SETTINGS) && SETTINGS['site_admin_email'] 
    default :from => SETTINGS['site_admin_email']
  else
    default :from => 'test@example.com'
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.password_reset.subject
  #
  def password_reset(user)  
    @user = user
    if defined?(SETTINGS) && SETTINGS['site_name']
      mail :to => user.email, :subject => t('authentication.password_reset_email_subject') + ' | ' + SETTINGS['site_name']
    else
      mail :to => user.email, :subject => t('authentication.password_reset_email_subject')
    end
  end

end