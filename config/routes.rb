Rails.application.routes.draw do
  post '/auth/user_token' => 'user_token#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount API::Base, at: "/api"
end
