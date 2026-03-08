require 'rails_helper'

RSpec.describe "Authors", type: :request do
  describe 'GET /index' do
    let!(:authors) { create_list(:author, 3) }

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        get '/api/authors'
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include('You need to sign in or sign up before continuing.')
      end
    end

    context 'when user is authenticated' do
      let(:user) { create(:user) }
      it 'returns authors' do
        token = login(user)
        get '/api/authors', headers: { 'Authorization' => "Bearer #{token}" }

        expect(response.body).to eq(AuthorSerializer.new(authors).serializable_hash.to_json)
        expect(response).to have_http_status(:success)
      end
    end
  end

  def login(user)
    post '/api/login', params: { email: user.email, password: user.password }
    JSON.parse(response.body)['token']
  end
end
