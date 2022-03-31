require 'sidekiq/web'

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_interslice_session"

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'

  post 'api/v1/authenticate', to: 'authentication#authenticate'
  post 'api/v1/password/forgot', to: 'password#forgot'
  post 'api/v1/password/reset', to: 'password#reset'

  post 'api/v1/user', to: 'user#create'
  get 'api/v1/bank_account', to: 'bank_account#show_all_by_user'
  post 'api/v1/bank_account', to: 'bank_account#create'
  post 'api/v1/trades', to: 'trade#create'
  get 'api/v1/trades/all', to: 'trade#all_trades'
  get 'api/v1/trades/:id', to: 'trade#show'
  get 'api/v1/trades', to: 'trade#show_all_by_user'
  delete 'api/v1/trades/:id', to: 'trade#delete'
  put 'api/v1/trades/:id', to: 'trade#update'
  patch 'api/v1/trades/:id', to: 'trade#update'
end
