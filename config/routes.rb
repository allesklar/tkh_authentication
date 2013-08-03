Rails.application.routes.draw do
  scope "(:locale)", locale: /#{I18n.available_locales.join("|")}/ do
    get 'signup', to: 'users#new', as: 'signup'
    get 'login', to: 'sessions#new', as: 'login'
    get 'logout', to: 'sessions#destroy', as: 'logout'

    resources :users do
      member do
        post :make_admin
        post :remove_admin
      end
      collection { post :detect_existence }
    end
    resources :sessions
    resources :password_resets
  end
end
