class CreateIslandListings < ActiveRecord::Migration[6.0]
  def change
    create_table :island_listings do |t|
      t.string :island_name
      t.string :player_name
      t.string :dodo_code
      t.string :description
      t.integer :player_count

      t.timestamps
    end
  end
end
