Rails.application.routes.draw do
  mount Ckeditor::Engine => '/ckeditor'
  mount RailsAdmin::Engine => '/radmin', as: 'rails_admin'
  post '/auth/user_token' => 'user_token#create'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  mount API::Base, at: "/api"
  mount API::Auth::Base, at: '/auth'
end
