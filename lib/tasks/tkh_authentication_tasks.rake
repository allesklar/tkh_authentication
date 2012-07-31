namespace :tkh_authentication do
  desc "Create migrations and locale files"
  task :install do
    system 'rails g tkh_authentication:create_migration'
    system 'rails g tkh_authentication:create_or_update_locales'
  end
end



