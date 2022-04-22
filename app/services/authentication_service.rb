class AuthenticationService
  # TODO: Verify implementation
  def self.decode_token(request)
    token = request.headers['Authorization'].split[1]

    JWT.decode(token, secret)[0]
  end

  def self.encode(user_data)
    payload = { user_id: user_data.id, exp: expires_in }
    JWT.encode(payload, secret)
  end

  def self.expires_in
    token_expiration_time = ENV.fetch('JWT_EXPIRATION_TIME', nil) || 2.hours.since
    (Time.now.to_i + 1) * token_expiration_time.to_i
  end

  def self.secret
    ENV.fetch('JWT_SECRET', nil) || 'jwtttw'
  end
end
