class UserMailer < ApplicationMailer
  def welcome(user)
    send_user_email user, "Welcome to Wefit!"
  end
  def password_reset(user)
    send_user_email user, "Password reset"
  end
  def feedback(user)
    send_user_email user, "Feedback!"
  end
  def weekly_roundup(user)
    week = Analysis.order(created_at: :desc).last.try(:week)
    return unless week.present?
    @analysis = Analysis.select("sum(analyses.users_count) as users_count, sum(analyses.posts_count) as posts_count, 
      sum(analyses.activities_count) as activities_count, sum(analyses.groups_count) as groups_count,
      sum(analyses.groups_joined_count) as members_count").where(week: week)
    send_weekly_email user, "Weekly Roundup!", analysis
  end

private
	def send_user_email(user, subject)
		@user = user
    mail to: user.email, subject: subject
	end

end