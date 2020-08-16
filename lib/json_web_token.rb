class JsonWebToken
  SECRET_KEY = Rails.application.secrets.secret_key_base.to_s
  LEEWAY = 60 # seconds

  def self.encode(payload, exp=24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET_KEY)
  end
  def self.decode(token)
    decoded = JWT.decode(token, SECRET_KEY, true, { exp_leeway: LEEWAY })[0]
    HashWithIndifferentAccess.new decoded
  end
end
