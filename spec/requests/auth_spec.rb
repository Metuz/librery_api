require 'rails_helper'

RSpec.describe 'Auth', type: :request do
  describe 'POST /login' do
    let(:user) { create(:user) }

    it 'returns a token with valid credentials' do
      post '/api/login', params: { email: user.email, password: user.password }

      body = JSON.parse(response.body)

      expect(response).to have_http_status(:ok)
      expect(body['token']).to be_present
    end

    it 'returns unauthorized with invalid password' do
      post '/api/login', params: { email: user.email, password: 'wrongpassword' }


      expect(response).to have_http_status(:unauthorized)
    end
  end

  describe 'POST /logout' do
    let(:user) { create(:user) }

    it 'logs out successfully' do
      post '/api/login', params: { email: user.email, password: user.password }

      token = JSON.parse(response.body)['token']
      post '/api/logout', headers: { 'Authorization' => 'Bearer #{token}' }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['message']).to eq('Logged out successfully')
    end
  end
end
