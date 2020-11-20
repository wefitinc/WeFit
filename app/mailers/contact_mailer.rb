class ContactMailer < ApplicationMailer
	def mail_contact(name,email,body)
		@name = name
		@email = email
		@body = body
		mail to: 'kyle@wefit.us', reply_to: email, subject: "Contact request"
	end
end