class ReceptionMailer < ActionMailer::Base
  default from: "#{Setting.first.try(:site_name)} <#{Setting.first.try(:contact_email)}>"

  def verification_email(user)
    @user = user
    mail(to: @user.email, subject: "Email validation for #{Setting.first.try(:site_name)}")
  end
end
