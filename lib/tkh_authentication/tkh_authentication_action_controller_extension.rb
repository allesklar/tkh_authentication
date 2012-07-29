module TkhAuthenticationActionControllerExtension
  def self.included(base)
    base.send(:include, InstanceMethods) 
    # base.before_filter :authenticate
    # base.after_filter :my_method_2
  end

  module InstanceMethods
    def current_user
      @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
    end

    def authenticate
      redirect_to login_url, alert: t('authentication.warning.login_needed') if current_user.nil?
    end
  end
end
