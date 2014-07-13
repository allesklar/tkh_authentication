Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do

    # legacy routes. Pointing to new pathway.
    get 'signup', to: 'reception#email_input', as: 'signup'
    get 'login', to: 'reception#email_input', as: 'login'
    get 'logout', to: 'reception#disconnect', as: 'logout'

    resources :users do
      member do
        post :make_admin
        post :remove_admin
      end
      collection { post :detect_existence }
    end
    resources :sessions
    resources :password_resets

    # New access control pathway
    get '/reception', to: 'reception#email_input', as: 'email_input'
    post '/parse_email', to: 'reception#parse_email'
    get '/email_validation', to: 'reception#email_validation'
    get '/create_your_password', to: 'reception#create_your_password'
    post '/password_creation/:id', to: 'reception#password_creation', as: 'password_creation'
    get '/enter_your_password', to: 'reception#enter_your_password'
    post '/password_checking/:id', to: 'reception#password_checking', as: 'password_checking'
    get '/disconnect', to: 'reception#disconnect'
  end
end
