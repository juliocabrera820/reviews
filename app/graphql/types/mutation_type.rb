module Types
  class MutationType < Types::BaseObject
    field :create_user, mutation: Mutations::CreateUser, description: 'Create a user'
    field :sign_in_user, mutation: Mutations::SignInUser, description: 'Generate access token'
  end
end
