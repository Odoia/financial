Rails.application.routes.draw do
  post 'api/v1/authenticate', to: 'authentication#authenticate'

  post 'api/v1/user', to: 'user#create'
end
