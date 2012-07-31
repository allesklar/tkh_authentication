require 'rails/generators/migration'
 
module TkhAuthentication
  module Generators
    class InstallGenerator < ::Rails::Generators::Base
      include Rails::Generators::Migration
      source_root File.expand_path('../templates', __FILE__)
      desc "add the migrations and locale files"
      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end
 
      def copy_migrations
        puts 'creating user migration'
        migration_template "create_users.rb", "db/migrate/create_users.rb"
      end
      
      def copy_locales
        puts 'creating locale files'
        I18n.available_locales.each do |l|
          copy_file "locales/#{l.to_s}.yml", "config/locales/tkh_authentication.#{l.to_s}.yml"
        end
      end
 
    end
  end
end