class ChangeUserIdToUnique < ActiveRecord::Migration[6.0]
  def change
    change_column :island_listings, :user_id, :integer, null: false, unique: true
  end
end
