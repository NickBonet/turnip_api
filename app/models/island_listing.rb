# frozen_string_literal: true

class IslandListing < ApplicationRecord
  belongs_to :user, class_name: 'User', foreign_key: 'user_id'
  validates_uniqueness_of :user_id

  rails_admin do
    edit do
      configure :description, :ck_editor
    end
  end
end
