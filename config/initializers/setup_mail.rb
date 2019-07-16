ActionMailer::Base.smtp_settings =
{
  :address              => "email-smtp.us-west-2.amazonaws.com",
  :port                 => 587,
  :domain               => "wefit.us",
  :user_name            => "AKIAUSVCBYR7MJ4Q4E4N",
  :password             => "BFHrV69/elL9LPP4llPtVqfwFG6o6hMtb3nEmTh7/x7L",
  :authentication       => "login",
  :enable_starttls_auto => true
}