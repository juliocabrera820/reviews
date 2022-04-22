require 'rails_helper'

RSpec.describe Queries::FetchUsers, type: :request do
  describe '.resolve' do
    context 'no users' do
      it 'does not return users' do
        post '/graphql', params: { query: query }
        data = JSON.parse(response.body, symbolize_names: true)

        users = data.dig(:data, :fetchUsers)

        expect(response).to have_http_status(:ok)
        expect(users.size).to eq 0
      end
    end

    context 'with created users' do
      it 'retrieves all users' do
        FactoryBot.create_list(:random_user, 3)
        post '/graphql', params: { query: query }
        data = JSON.parse(response.body, symbolize_names: true)

        users = data.dig(:data, :fetchUsers)

        expect(response).to have_http_status(:ok)
        expect(users.size).to eq 3
      end
    end

    def query
      <<~GQL
        query {
          fetchUsers {
            id
            username
            email
          }
        }
      GQL
    end
  end
end
