Rails.application.routes.draw do
  post 'api/v1/authenticate', to: 'authentication#authenticate'

  post 'api/v1/user', to: 'user#create'
  get 'api/v1/user/:id/bank_account', to: 'bank_account#show_all_by_user'
  post 'api/v1/bank_account', to: 'bank_account#create'
end
