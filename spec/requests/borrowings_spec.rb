require 'rails_helper'

RSpec.describe 'Borrowing', type: :request do
  let(:user)          { create(:user, role: :member) }
  let(:book)          { create(:book) }
  let(:login_message) { 'You need to sign in or sign up before continuing.'}
  
  describe 'POST /create' do
    let(:attrs) do
      {
        borrowing: {
          user_id: user.id,
          book_id: book.id,
          borrowed_at: Date.today
        }
      }
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        post '/api/borrowings', params: attrs
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include(login_message)
      end
    end

    context 'when user is authenticated' do
      it 'allows member to borrow a book' do
        token = login(user)
        post '/api/borrowings', params: attrs, headers: { 'Authorization' => "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        expect(response.body).to include('Borrowing created successfully')
      end
    end
  end

  describe 'PATCH /return' do
    let(:borrowing)  { create(:borrowing, user: user, book: book) }

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        patch "/api/borrowings/#{borrowing.id}/return"
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include(login_message)
      end
    end

    context 'when user is authenticated' do
      it 'allows member to return a book' do
        token = login(user)
        patch "/api/borrowings/#{borrowing.id}/return", headers: { 'Authorization' => "Bearer #{token}" }
        expect(response).to have_http_status(:success)
        expect(response.body).to include('Book returned successfully')
      end
    end

    context 'when borrowing is already returned' do
      before do
        borrowing.update(returned_at: Date.today)
      end

      it 'returns not found' do
        token = login(user)
        patch "/api/borrowings/#{borrowing.id}/return", headers: { 'Authorization' => "Bearer #{token}" }
        expect(response).to have_http_status(:not_found)
      end
    end

    context 'when borrowing does not exist' do
      it 'returns not found' do
        token = login(user)
        patch "/api/borrowings/999/return", headers: { 'Authorization' => "Bearer #{token}" }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  def login(user)
    post '/api/login', params: { email: user.email, password: user.password }
    JSON.parse(response.body)['token']
  end
end
