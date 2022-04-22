module Mutations
  class CreateUser < Mutations::BaseMutation
    class AuthProviderSignupData < Types::BaseInputObject
      argument :credentials, Types::Input::AuthenticationProviderCredentialsInput, required: true
    end

    argument :username, String, required: true
    argument :authentication_provider, AuthProviderSignupData, required: true

    field :user, Types::UserType, null: false

    def resolve(username: nil, authentication_provider: nil)
      user = User.create!(username: username, email: authentication_provider&.[](:credentials)&.[](:email),
                          password: authentication_provider&.[](:credentials)&.[](:password))

      { user: user }
    rescue ActiveRecord::RecordInvalid => e
      GraphQL::ExecutionError.new(e.record.errors.full_messages.join(', '))
    end
  end
end
