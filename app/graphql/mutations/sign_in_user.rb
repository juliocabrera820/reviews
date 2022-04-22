module Mutations
  class SignInUser < Mutations::BaseMutation
    argument :credentials, Types::Input::AuthenticationProviderCredentialsInput, required: true

    field :token, String, null: true
    field :user, Types::UserType, null: true

    def resolve(credentials: nil)
      user = User.find_by(email: credentials[:email])
      return GraphQL::ExecutionError.new('User does not exist') unless user

      return GraphQL::ExecutionError.new('Invalid credentials') unless user.authenticate(credentials[:password])

      token = AuthenticationService.encode(user)

      { user: user, token: token }
    end
  end
end
