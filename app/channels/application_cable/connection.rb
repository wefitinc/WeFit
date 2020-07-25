module ApplicationCable
  class Connection < ActionCable::Connection::Base
  	identified_by :current_user

  	def connect
      # First, set the current user
  	  self.current_user = find_verified_user
  	end

  	private
  	def find_verified_user
  	  # Get the authorization token from the header
      header = request.headers['Authorization']
      header = header.split(' ').last if header
      if not header.nil?
        begin
          # Try and decode the token
          @decoded = JsonWebToken.decode(header)
          # Get the user by the user ID from the token
          @current_user = User.find_by_hashid(@decoded[:user_id])
        rescue JWT::DecodeError => e
          # If theres an error decoding the token, respond with the error and a 401 status
          transmit error: e.message
          reject_unauthorized_connection 
        end
      else
        transmit error: "Authorization token required"
        reject_unauthorized_connection 
      end	
      # Return an error if the user doesn't exist 
      # NOTE: This should not happen, the token is encoded and signed with the secret key
      # But just in case there's a server error or something
      if @current_user.nil?
        transmit error: "User not found" 
        reject_unauthorized_connection 
      else
        @current_user
      end
  end
end
