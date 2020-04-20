class SignupConfirmMailer < ApplicationMailer
  default from: ENV['SMTP_USERNAME']

  def confirmation_email(user, token)
    @user = user
    @url = "#{ENV['HOST']}/auth/signup_confirm?email=#{@user.email}&confirm_token=#{token}"
    mail(to: @user.email, subject: 'Confirm your Project Turnip account!')
  end
end
