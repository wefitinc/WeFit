class UserMailer < ApplicationMailer
  def password_reset(user)
    @user = user
    mail to: user.email, subject: "Password reset"
  end
  def welcome(user)
    @user = user
    mail to: user.email, subject: "Welcome to Wefit!"
  end
end