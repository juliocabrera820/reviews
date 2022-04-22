module Types
  module Input
    class AuthenticationProviderCredentialsInput < Types::BaseInputObject
      graphql_name 'AUTHENTICATION_PROVIDER_CREDENTIALS'

      argument :email, String, required: true
      argument :password, String, required: true
    end
  end
end
