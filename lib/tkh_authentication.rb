require "tkh_authentication/version"
# require 'bcrypt-ruby'
require 'simple_form'
require 'stringex'
require 'tkh_authentication/tkh_authentication_action_controller_extension'
require 'tkh_authentication/tkh_authentication_helper'

module TkhAuthentication
  class Engine < ::Rails::Engine
    # to extend the application helper in the host app
    initializer 'tkh_authentication.helper' do |app|  
      ActionView::Base.send :include, TkhAuthenticationHelper  
    end  
    # to extend the application_controller in the host app
    initializer 'tkh_authentication.controller' do |app|
      ActiveSupport.on_load(:action_controller) do  
         include TkhAuthenticationActionControllerExtension  
      end
    end    
  end
end