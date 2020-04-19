# frozen_string_literal: true

module API
  module Auth
    class Users < Grape::API
      version 'v1', using: :header, vendor: 'K-Shadow'
      format :json
      password_regex = %r{^(?=.*\d)(?=.*[~!@#$%^&*()_\-+=|\\\{\}\[\]:;<>?\/])(?=.*[A-Z])(?=.*[a-z])\S{8,40}$}

      helpers do
        # If the client is even sending an Authorization header, ignore the request.
        def authorized?
          if headers.key?('Authorization')
            true
          else
            false
          end
        end
      end

      resource :users do
        desc 'Add a new user to the database.'
        params do
          requires :username, type: String, regexp: /^[A-Za-z][A-Za-z0-9_-]{3,29}$/
          requires :email, type: String,
                           regexp: URI::MailTo::EMAIL_REGEXP
          requires :password, type: String, regexp: password_regex
          requires :password_confirm, type: String, regexp: password_regex
        end
        post do
          if !authorized?
            if params[:password] == params[:password_confirm]
              User.create!(name: params[:username], email: params[:email], password: params[:password])
            else
              body 'Passwords do not match!'
              status 422
            end
          else
            body 'You are already logged in!'
            status 403
          end
        end
      end

      resource :users do
        use Grape::Knock::Authenticable
        desc "Update a user's details."
        params do
          requires :password, type: String, regexp: password_regex
          requires :password_confirm, type: String, regexp: password_regex
        end
        put do
          if params[:password] == params[:password_confirm]
            user = User.find_by!(id: current_user.id)
            user.update!(password: params[:password])
          else
            body 'Passwords do not match!'
            status 422
          end
        end
      end

      rescue_from Grape::Knock::ForbiddenError do
        error!('403 Forbidden', 403)
      end
    end
  end
end
