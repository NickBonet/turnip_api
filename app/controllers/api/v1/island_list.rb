module API
  module V1
    class IslandList < Grape::API
      version 'v1', using: :header, vendor: 'K-Shadow'
      format :json

      # Requests that don't require auth.
      resource :islands do
        desc 'Return all island listings.'
        get :all do
          IslandListing.all
        end

        desc 'Get speciifc island listing by ID.'
        params do
          requires :id, type: Integer
        end
        get do
          IslandListing.find_by(id: params[:id])
        end
      end

      resource :islands do
        use Grape::Knock::Authenticable
        desc 'Adds a mew island listing.'
        params do
          requires :island_name, type: String, desc: 'Name of the island'
          requires :player_name, type: String, desc: 'Player name'
          requires :dodo_code, type: String, desc: 'Dodo code'
          requires :description, type: String, desc: 'Description of island/event'
        end
        post do
          IslandListing.create!(island_name: params[:island_name], player_name: params[:player_name],
          dodo_code: params[:dodo_code], description: params[:description], player_count: 1, user_id: current_user.id)
        end

        desc 'Delete an island listing.'
        params do
          requires :id, type: Integer
        end
        delete do
          IslandListing.delete(params[:id])
        end
        
        desc 'Allows for updating Dodo Code and player count.'
        params do
          requires :id, type: Integer
          requires :dodo, type: String
          requires :count, type: Integer
        end
        put do
          island = IslandListing.find_by!(id: params[:id])
          island.update!(dodo_code: params[:dodo], player_count: params[:player_count])
        end
      end

      rescue_from Grape::Knock::ForbiddenError do
        error!('403 Forbidden', 403)
      end
    end
  end
end