require 'rails_helper'

RSpec.describe Mutations::CreateUser, type: :request do
  describe '.resolve' do
    context 'with valid attributes' do
      it 'returns a new user' do
        post '/graphql', params: { query: query(username: 'juju', email: 'juju@gmail.com', password: '12345') }
        data = JSON.parse(response.body, symbolize_name: true).with_indifferent_access

        puts data.inspect
        user = data.dig(:data, :createUser, :user)

        expect(response).to have_http_status(:ok)
        expect(user).to include(:username, :email)
        expect(user).to eq(
          'username' => 'juju',
          'email'    => 'juju@gmail.com' 
        )
      end
    end

    context 'with invalid username' do
      it 'returns message error about username field' do
        post '/graphql', params: { query: query(username: '', email: 'juju@gmail.com', password: '12345') }
        data = JSON.parse(response.body, symbolize_name: true).with_indifferent_access

        user = data.dig(:data, :createUser, :user)
        error = data.fetch(:errors)[0].fetch(:message)

        expect(response).to have_http_status(:ok)
        expect(user).to be_nil
        expect(error).to eq "Username can't be blank"
      end
    end

    context 'with invalid password' do
      it 'returns message error about password field' do
        post '/graphql', params: { query: query(username: 'ari', email: 'juju@gmail.com', password: '') }
        data = JSON.parse(response.body, symbolize_name: true).with_indifferent_access

        user = data.dig(:data, :createUser, :user)
        error = data.fetch(:errors)[0].fetch(:message)

        expect(response).to have_http_status(:ok)
        expect(user).to be_nil
        expect(error).to eq "Password can't be blank, Password can't be blank"
      end
    end

    context 'with existing email' do
      it 'returns message error about email field' do
        FactoryBot.create(:user, email: 'juju@gmail.com')
        post '/graphql', params: { query: query(username: 'ju', email: 'juju@gmail.com', password: '12345') }
        data = JSON.parse(response.body, symbolize_name: true).with_indifferent_access

        user = data.dig(:data, :createUser, :user)
        error = data.fetch(:errors)[0].fetch(:message)

        expect(response).to have_http_status(:ok)
        expect(user).to be_nil
        expect(error).to eq 'Email has already been taken'
      end
    end

    
    def query(username:, email:, password:)
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
