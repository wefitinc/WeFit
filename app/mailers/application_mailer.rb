class ApplicationMailer < ActionMailer::Base
  add_template_helper(EmailHelper)
  default from: 'noreply@wefit.us'
  layout 'mailer'
end
