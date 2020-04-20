# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_one :island_listing, dependent: :destroy

  validates_presence_of     :email
  validates_presence_of     :name
  validates_uniqueness_of   :email
  validates_uniqueness_of   :name

  after_create :send_confirm_email

  def send_confirm_email
    confirm_token = SecureRandom.urlsafe_base64.to_s
    # Expire the sign up token in a day. TODO: will clean up unconfirmed users daily from DB.
    $redis.set(self.email, confirm_token, :ex => 86400, :nx => true) 
    SignupConfirmMailer.confirmation_email(self, confirm_token).deliver
  end

  def self.from_token_request request
    if request.params['auth'].key?('email')
      user = self.find_by email: request.params['auth']['email']
      if user.confirmed?
        user
      end
    end
  end
end
