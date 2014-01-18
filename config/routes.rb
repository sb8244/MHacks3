Ruby2::Application.routes.draw do
  root 'home#index'
  resources :watches
  devise_for :users,
    :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

end
