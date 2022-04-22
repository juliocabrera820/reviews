class AuthenticationService
  SECRET = ENV.fetch('JWT_SECRET')
  TOKEN_EXPIRATION_TIME = ENV.fetch('JWT_EXPIRATION_TIME').to_i
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
end
