class UserMailer < ApplicationMailer
  def password_reset(user)
    send_user_email user, "Password reset"
  end
  def welcome(user)
    send_user_email user, "Welcome to Wefit!"
  end
  def feedback(user)
    send_user_email user, "Feedback!"
  end
  def weekly_roundup(user)
    send_user_email user, "Weekly Roundup!"
  end

private
	def send_user_email(user, subject)
		@user = user
    mail to: user.email, subject: subject
	end
end
