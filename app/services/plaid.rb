class Plaid

	def initialize
		@secret_key_base = Rails.application.secrets.jwt_secret_key
		@refresh_token_secret_key_base = Rails.application.secrets.jwt_secret_refresh_token_key
		@jwt_issuer = Rails.application.secrets.jwt_issuer
		@options = { algorithm: JWT_Algorithm, iss: @jwt_issuer }
	end

  def encode(user_id=nil, scopes=[])
  	# Scopes are defined for role based authorization. Giving only certain APIs access to user based on role.
  	@payload = payload(user_id, scopes, 30 * 24 * 60 * 60)
    return JWT.encode(@payload, @secret_key_base, JWT_Algorithm) rescue nil
  end

  def decode(token)
    return JWT.decode(token, @secret_key_base, true, @options)
  end

  def payload(user_id, scopes, expiry)
  	{
	    exp: Time.now.to_i + expiry,
	    iat: Time.now.to_i,
	    iss: @jwt_issuer,
	    scopes: scopes,
	    user_id: user_id
	  }
  end

  def encode_refresh_token(user_id=nil, scopes=[])
  	# Scopes are defined for role based authorization. Giving only certain APIs access to user based on role.
  	@payload = payload(user_id, scopes, 365 * 24 * 60 * 60)
    return JWT.encode(@payload, @refresh_token_secret_key_base, JWT_Algorithm) rescue nil
  end

  def decode_refresh_token(token)
    return JWT.decode(token, @refresh_token_secret_key_base, true, @options)
  end

end