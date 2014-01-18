Ruby2::Application.routes.draw do
  root 'application#index'
  get '/proxy', to: 'proxy#index'
  get '/category', to: 'category#index'
  get '/user/status', to: 'user#logged'
  resources :watches
  devise_for :users,
    :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

end
