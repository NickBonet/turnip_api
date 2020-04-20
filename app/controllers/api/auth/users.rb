# frozen_string_literal: true
module API
  module Auth
    class Users < Grape::API
      version 'v1', using: :header, vendor: 'K-Shadow'
      format :json
      password_regex = %r{^(?=.*\d)(?=.*[~!@#$%^&*()_\-+=|\\\{\}\[\]:;<>?\/])(?=.*[A-Z])(?=.*[a-z])\S{8,40}$}
      username_regex = /^[A-Za-z][A-Za-z0-9_-]{3,29}$/

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

      resource :signup_confirm do
        desc 'Validates a signup confirmation token.'
        params do
          requires :confirm_token, type: String, allow_blank: false
          requires :email, type: String,
                           regexp: URI::MailTo::EMAIL_REGEXP
        end
        post do
          if !authorized?
            stored_token = $redis.get(params[:email])
            if (stored_token == params[:confirm_token])
              user = User.find_by!(email: params[:email])
              user.update!(confirmed: true)
              $redis.del(params[:email])
              status 200
              { status: 'Your account is confirmed.' }
            else
              status 404
              { status: 'Confirmation token not found.' }
            end
          else
            status 403
            { status: 'You are already logged in!' }
          end
        end
      end

      resource :users do
        desc 'Add a new user to the database'
        params do
          requires :username, type: String, regexp: username_regex
          requires :email, type: String,
                           regexp: URI::MailTo::EMAIL_REGEXP
          requires :password, type: String, regexp: password_regex
          requires :password_confirm, type: String, regexp: password_regex, same_as: :password
        end
        post do
          if !authorized?
            User.create!(name: params[:username], email: params[:email], password: params[:password])
            confirm_token = SecureRandom.urlsafe_base64.to_s
            # Expire the sign up token in a day. TODO: will clean up unconfirmed users daily from DB.
            $redis.set(params[:email], confirm_token, :ex => 86400, :nx => true) 
            # TODO: need to send token URL in email
            { status: 'User created. Must be confirmed before logging in.' }
          else
            status 403
            { status: 'You are already logged in!' }
          end
        end
      end

      resource :users do
        use Grape::Knock::Authenticable
        desc "Update a user's details."
        params do
          requires :password, type: String, regexp: password_regex
          requires :password_confirm, type: String, regexp: password_regex, same_as: :password
        end
        put do
          user = User.find_by!(id: current_user.id)
          user.update!(password: params[:password])
        end
      end

      rescue_from Grape::Knock::ForbiddenError do
        error!('403 Forbidden', 403)
      end
    end
  end
end
