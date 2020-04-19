class ChangeUserNameToUnique < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :name, :string, null: false, unique: true
  end
end
