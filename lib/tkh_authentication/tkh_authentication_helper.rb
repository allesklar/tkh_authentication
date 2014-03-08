module TkhAuthenticationHelper
  def self.included(base)
    base.send(:include, InstanceMethods)
    # base.before_filter :current_user
    # base.after_filter :my_method_2
  end

  module InstanceMethods
    # duplicated from action controller extension. there must be a better way
    def current_user
      @current_user ||= User.find_by!(auth_token: cookies[:auth_token]) if cookies[:auth_token]
    end

    # duplicated from action controller extension. there must be a better way
    def administrator?
      @administrator ||= current_user && current_user.admin?
    end
  end
end
