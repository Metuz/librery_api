require 'rails_helper'

RSpec.describe "Genres", type: :request do
  describe 'GET /index' do
    let!(:genres) { create_list(:genre, 3) }

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        get '/api/genres'
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end

    context 'when user is authenticated' do
      let(:user) { create(:user) }
      it 'returns genres' do
        token = login(user)
        get '/api/genres', headers: { 'Authorization' => "Bearer #{token}" }

        expect(response.body).to eq(GenreSerializer.new(genres).serializable_hash.to_json)
        expect(response).to have_http_status(:success)
      end
    end
  end

  def login(user)
    post '/api/login', params: { email: user.email, password: user.password }
    JSON.parse(response.body)['token']
  end
end
