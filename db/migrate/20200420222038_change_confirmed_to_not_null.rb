class ChangeConfirmedToNotNull < ActiveRecord::Migration[6.0]
  def change
    change_column :users, :confirmed, :boolean, null: false, default: false
  end
end
