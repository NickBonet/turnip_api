class AddUserIdToIslandListings < ActiveRecord::Migration[6.0]
  def change
    add_reference :island_listings, :user, foreign_key: true
    change_column :island_listings, :user_id, :integer, null: false
  end
end
