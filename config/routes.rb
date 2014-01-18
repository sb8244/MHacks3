Ruby2::Application.routes.draw do
  root 'application#index'
  get '/home', to: 'home#index'
  get '/user/status', to: 'home#logged'
  resources :watches
  devise_for :users,
    :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

end
