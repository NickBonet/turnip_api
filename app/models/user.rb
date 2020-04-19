# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_one :island_listing, dependent: :destroy

  validates_presence_of     :email
  validates_presence_of     :name
  validates_uniqueness_of   :email
  validates_uniqueness_of   :name
end
