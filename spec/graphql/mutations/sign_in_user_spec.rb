require 'rails_helper'

RSpec.describe Mutations::SignInUser, type: :request do
  describe '.resolve' do
    before do
      post '/graphql', params: { query: create_user_mutation(username: 'juju', email: 'juju@gmail.com', password: '12345') }
    end

    context 'with correct credentials' do
      it 'returns sign in data' do
        post '/graphql', params: { query: query(email: 'juju@gmail.com', password: '12345') }
        data = JSON.parse(response.body, symbolize_name: true).with_indifferent_access

        sign_in_data = data.dig(:data, :signInUser)

        expect(response).to have_http_status(:ok)
        expect(sign_in_data).to include(:token)
      end
    end

    context 'with non existing email' do
      it 'returns message error about email' do
        post '/graphql', params: { query: query(email: 'j@gmail.com', password: '12345') }
        data = JSON.parse(response.body, symbolize_name: true).with_indifferent_access

        error = data.fetch(:errors)[0].fetch(:message)

        expect(response).to have_http_status(:ok)
        expect(error).to eq 'User does not exist'
      end
    end

    context 'with invalid credentials' do
      it 'returns message error about credentials' do
        post '/graphql', params: { query: query(email: 'juju@gmail.com', password: '123456789') }
        data = JSON.parse(response.body, symbolize_name: true).with_indifferent_access

        error = data.fetch(:errors)[0].fetch(:message)

        expect(response).to have_http_status(:ok)
        expect(error).to eq 'Invalid credentials'
      end
    end

    def query(email: nil, password: nil)
      <<~GQL
        mutation {
          signInUser(input: { credentials: { email: "#{email}", password: "#{password}" } }) {
            token
          }
        }
      GQL
    end

    def create_user_mutation(username:, email:, password:)
      <<~GQL
        mutation {
          createUser(input: { username: "#{username}", authenticationProvider: { credentials: { email: "#{email}", password: "#{password}" } } }) {
            user {
              username
              email
            }
          }
        }
      GQL
    end
  end
end

