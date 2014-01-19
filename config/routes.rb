Ruby2::Application.routes.draw do
  root 'application#index'
  get '/proxy', to: 'proxy#index'
  get '/category/list', to: 'category#list'
  get '/user/status', to: 'user#logged'
  resources :watches
  devise_for :users,
    :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }

end
