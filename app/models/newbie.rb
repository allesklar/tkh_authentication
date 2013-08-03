class Newbie < User

  def send_password_set
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    # necessary to pass has_secure_password validations
    self.password, self.password_confirmation = 'temporary', 'temporary'
    save!
    UserMailer.password_set(self).deliver
  end

end
