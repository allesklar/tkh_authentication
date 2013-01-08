module TkhAuthenticationActionControllerExtension
  def self.included(base)
    base.send(:include, InstanceMethods) 
  end

  module InstanceMethods
    def current_user
      @current_user ||= User.find_by_auth_token!(cookies[:auth_token]) if cookies[:auth_token]
    end

    def authenticate
      if current_user.nil?
        session[:target_page] = request.url
        redirect_to login_url, alert: t('authentication.warning.login_needed')
      end
    end
    
    def authenticate_with_admin
      unless administrator?
        session[:target_page] = request.url if session[:target_page].nil?
        redirect_to safe_root_url, alert: t('authentication.warning.restricted_access')
      end
    end
    
    def administrator?
      current_user && current_user.admin?
    end
    
    private
    
    def safe_root_url
      defined?(root_url) ? root_url : '/'
    end
  end
end
