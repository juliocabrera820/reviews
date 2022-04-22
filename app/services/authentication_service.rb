class AuthenticationService
  SECRET = ENV.fetch('JWT_SECRET', nil) || default_secret
  TOKEN_EXPIRATION_TIME = ENV.fetch('JWT_EXPIRATION_TIME', nil).to_i || expires_in
  EXPIRATION_TIME = (Time.now.to_i + 1) * TOKEN_EXPIRATION_TIME

  # TODO: Verify implementation
  def self.decode_token(request)
    token = request.headers['Authorization'].split[1]

    JWT.decode(token, SECRET)[0]
  end

  def self.encode(user_data)
    payload = { user_id: user_data.id, exp: EXPIRATION_TIME }
    JWT.encode(payload, SECRET)
  end

  def self.expires_in
    2.hours.since.to_i
  end

  def self.default_secret
    'jwtttj'
  end
end
