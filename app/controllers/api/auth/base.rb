module API
  module Auth
    class Base < Grape::API
      mount API::Auth::Users
    end
  end
end