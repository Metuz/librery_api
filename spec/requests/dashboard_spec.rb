require 'rails_helper'

RSpec.describe "Dashboards", type: :request do
  let(:user)          { create(:user, role: role) }
  let(:book)          { create(:book) }
  let(:login_message) { 'You need to sign in or sign up before continuing.'}

  describe "GET /index" do
    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        get '/api/dashboard'
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include(login_message)
      end
    end

    context 'when user is authenticated' do
      context 'when user is librarian' do
        let(:role)                { :librarian }
        let!(:book)               { create(:book, total_copies: 2) }
        let!(:user_1)             { create(:user, role: :member) }
        let!(:user_2)             { create(:user, role: :member) }
        let!(:borrowings)         { create(:borrowing, book: book, user: user_1, borrowed_at: 1.week.ago, returned_at: 1.day.ago) }
        let!(:overdue_borrowing)  { create(:borrowing, book: book, user: user_2, borrowed_at: 3.weeks.ago) }
        let(:expected_response) do
          {
            'total_books' => Book.count,
            'total_books_borrowed' => 2,
            'overdue_books' => 1,
            'members_with_overdue_books' => [{ 'id' => user_2.id, 'name' => user_2.name }]
          }
        end

        it 'returns dashboard data' do
          token = login(user)
          get '/api/dashboard', headers: { 'Authorization' => "Bearer #{token}" }
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)).to eq(expected_response)
        end
      end

      context 'when user is member' do
        let(:role)       { :member }
        let!(:borrowing) { create(:borrowing, book: book, user: user, borrowed_at: 3.week.ago) }
        let(:expected_response) do
          {
            'borrowed_books' => [
              {
                'id' => borrowing.id,
                'title' => book.title,
                'borrowed_at' => borrowing.borrowed_at.strftime('%Y-%m-%d'),
                'due_date' => borrowing.due_date.strftime('%Y-%m-%d'),
                'on_time' => nil,
                'returned' => false
              }
            ]
          }
        end

        it 'returns dashboard data' do
          token = login(user)
          get '/api/dashboard', headers: { 'Authorization' => "Bearer #{token}" }
          expect(response).to have_http_status(:success)
          expect(JSON.parse(response.body)).to eq(expected_response)
        end
      end
    end
  end

  def login(user)
    post '/api/login', params: { email: user.email, password: user.password }
    JSON.parse(response.body)['token']
  end
end
