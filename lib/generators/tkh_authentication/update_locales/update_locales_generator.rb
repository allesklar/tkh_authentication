require 'rails/generators/migration'
 
module TkhAuthentication
  module Generators
    class UpdateLocalesGenerator < ::Rails::Generators::Base
      # WARNING - sharing translations and using the ones from the install generator
      source_root File.expand_path('../templates', __FILE__)
      
      def copy_locales
        puts 'creating locale files'
        I18n.available_locales.each do |l|
          copy_file "locales/#{l.to_s}.yml", "config/locales/tkh_authentication.#{l.to_s}.yml"
        end
      end
 
    end
  end
end