class IslandListing < ApplicationRecord
  belongs_to :user, :class_name => 'User', :foreign_key => 'user_id'
  validates_uniqueness_of :user_id
end
