class ContactController < ApplicationController
	def new
	end
	def create
		@name = params[:name]
		@email = params[:email]
		@body = params[:body]
		ContactMailer.mail_contact(@name,@email,@body).deliver_now
		redirect_to root_path
	end
end
