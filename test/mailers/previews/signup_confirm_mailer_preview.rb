# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/signup_confirm_mailer
class SignupConfirmMailerPreview < ActionMailer::Preview
  def confirmation_email
    SignupConfirmMailer.confirmation_email(User.first, 'placeholder')
  end
end
