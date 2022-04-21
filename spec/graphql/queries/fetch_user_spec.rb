require 'rails_helper'

RSpec.describe Queries::FetchUser, type: :request do
  describe '.resolve' do
    context 'user does not exist' do
      let(:user_created) { FactoryBot.create(:user) }

      it 'returns a user' do
        post '/graphql', params: { query: query(user_created.id) }
        data = JSON.parse(response.body, symbolize_names: true)

        user = data.dig(:data, :fetchUser)

        expect(response).to have_http_status(:ok)
        expect(user.fetch(:username)).to eq 'jules'
        expect(user.fetch(:email)).to eq 'jules@gmail.com'
      end
    end

    context 'with existing user' do
      it 'does not return a user' do
        post '/graphql', params: { query: query(2) }

        data = JSON.parse(response.body, symbolize_names: true)

        expect(response).to have_http_status(:ok)
        expect(data.fetch(:data)).to be_nil
        expect(data.fetch(:errors)[0].fetch(:message)).to eq 'User does not exist'
      end
    end

    def query(id)
      <<~GQL
        query {
          fetchUser(id: #{id}) {
            id
            username
            email
          }
        }
      GQL
    end
  end
end
