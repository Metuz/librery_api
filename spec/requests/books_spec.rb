require 'rails_helper'

RSpec.describe 'Books', type: :request do
  describe 'GET /index' do
    let!(:books) { create_list(:book, 3) }

    it 'returns books' do
      get '/api/books'

      expect(response.body).to eq(BookSerializer.new(books).serializable_hash.to_json)
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /create' do
    it 'returns http success' do
      get '/books/create'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /update' do
    it 'returns http success' do
      get '/books/update'
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /destroy' do
    it 'returns http success' do
      get '/books/destroy'
      expect(response).to have_http_status(:success)
    end
  end

end
