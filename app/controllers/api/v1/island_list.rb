module API
  module V1
    class IslandList < Grape::API
      version 'v1', using: :header, vendor: 'K-Shadow'
      format :json

      resource :islands do
        desc 'Return all island listings.'
        get :all_listings do
          IslandListing.all
        end

        desc 'Adds a mew island listing.'
        params do
          requires :island_name, type: String, desc: 'Name of the island'
          requires :player_name, type: String, desc: 'Player name'
          requires :dodo_code, type: String, desc: 'Dodo code'
          requires :description, type: String, desc: 'Description of island/event'
        end
        post :add_island do
          IslandListing.create!(island_name: params[:island_name], player_name: params[:player_name],
          dodo_code: params[:dodo_code], description: params[:description])
        end
      end
    end
  end
end