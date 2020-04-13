module API
  module Auth
    class Users < Grape::API
      version 'v1', using: :header, vendor: 'K-Shadow'
      format :json

      helpers do
        # If the client is even sending an Authorization header, ignore the request.
        def authorized?
          if headers.key?("Authorization")
            return true
          else
            return false
          end
        end
      end

      resource :users do
        desc 'Add a new user to the database.'
        params do
          requires :username, type: String
          requires :email, type: String
          requires :password, type: String
          requires :password_confirm, type: String
        end
        post do
          if not authorized?
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
          requires :password, type: String
          requires :password_confirm, type: String
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
    end
  end
end