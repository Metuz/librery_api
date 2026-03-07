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

  let(:login_message) { 'You need to sign in or sign up before continuing.'}

  describe 'POST /create' do
    let(:author) { create(:author) }
    let(:genres) { create_list(:genre, 2) }
    let(:attrs) do
      {
        book: {
          title: Faker::Book.title,
          isbn: Faker::Code.isbn,
          author_id: author.id,
          genre_ids: [genres.map(&:id)]
        }
      }
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        post '/api/books', params: attrs
        expect(response).to have_http_status(:unauthorized)
        expect(response.body).to include(login_message)
      end
    end

    context 'when user is authenticated' do
      context 'when user is librarian' do
        let(:user) { create(:user) }

        context 'when all attributes are valid' do
          it 'returns http success' do
            token = login(user)
            post '/api/books', params: attrs, headers: { 'Authorization' => "Bearer #{token}" }
            expect(response).to have_http_status(:success)
            expect(response.body).to include('Book created successfully')
            expect(Book.last.title).to eq(attrs[:book][:title])
          end
        end

        context 'when attributes are invalid' do
          let(:attrs) do
            {
              book: {
                title: '',
                isbn: '',
                author_id: nil,
                genre_ids: []
              }
            }
          end
          let(:errors) { { 'errors' => ['Author must exist', "Title can't be blank", "Isbn can't be blank"] } }

          it 'returns http unprocessable entity' do
            token = login(user)
            post '/api/books', params: attrs, headers: { 'Authorization' => "Bearer #{token}" }
            expect(response).to have_http_status(:unprocessable_content)
            expect(JSON.parse(response.body)).to eq(errors)
          end
        end
      end

      context 'when user is member' do
        let(:user) { create(:user, role: 'member') }

        it 'returns http forbidden' do
          token = login(user)
          post '/api/books', params: attrs, headers: { 'Authorization' => "Bearer #{token}" }
          expect(response).to have_http_status(:forbidden)
          expect(JSON.parse(response.body)).to eq({ 'error' => 'Not authorized' })
        end
      end
    end
  end

  describe 'PATCH /update' do
    let!(:book) { create(:book) }
    let(:attrs) do
      {
        book: {
          title: Faker::Book.title,
          isbn: Faker::Code.isbn,
          author_id: book.author.id,
          genre_ids: [book.genres.map(&:id)]
        }
      }
    end

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        patch "/api/books/#{book.id}", params: attrs
         expect(response.body).to include(login_message)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is authenticated' do
      context 'when user is librarian' do
        let(:user) { create(:user) }

        context 'when all attributes are valid' do
          it 'returns http success' do
            token = login(user)
            patch "/api/books/#{book.id}", params: attrs, headers: { 'Authorization' => "Bearer #{token}" }
            expect(response).to have_http_status(:success)
            expect(response.body).to include('Book updated successfully')
            expect(Book.last.title).to eq(attrs[:book][:title])
          end
        end

        context 'when attributes are invalid' do
          let(:attrs) do
            {
              book: {
                title: '',
                isbn: '',
                author_id: nil,
                genre_ids: []
              }
            }
          end
          let(:errors) { { 'errors' => ['Author must exist', "Title can't be blank", "Isbn can't be blank"] } }

          it 'returns http unprocessable entity' do
            token = login(user)
            patch "/api/books/#{book.id}", params: attrs, headers: { 'Authorization' => "Bearer #{token}" }
            expect(JSON.parse(response.body)).to eq(errors)
            expect(response).to have_http_status(:unprocessable_content)
          end
        end
      end

      context 'when user is member' do
        let(:user) { create(:user, role: 'member') }

        it 'returns http forbidden' do
          token = login(user)
          patch "/api/books/#{book.id}", params: attrs, headers: { 'Authorization' => "Bearer #{token}" }
          expect(response).to have_http_status(:forbidden)
          expect(JSON.parse(response.body)).to eq({ 'error' => 'Not authorized' })
        end
      end
    end
  end

  describe 'GET /destroy' do
    let!(:book) { create(:book) }

    context 'when user is not authenticated' do
      it 'returns unauthorized' do
        delete "/api/books/#{book.id}"
        expect(response.body).to include(login_message)
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when user is authenticated' do
      context 'when user is librarian' do
        let(:user) { create(:user) }

        context 'when book exists' do
          context 'when does not have active borrowings' do
            it 'returns http success' do
              token = login(user)
              delete "/api/books/#{book.id}", headers: { 'Authorization' => "Bearer #{token}" }
              expect(response).to have_http_status(:success)
              expect(Book.exists?(book.id)).to be_falsey
            end
          end

          context 'when has active borrowings' do
            before do
              user = create(:user)
              create(:borrowing, book: book, user: user, returned_at: nil)
            end

            it 'returns http unprocessable entity' do
              token = login(user)
              delete "/api/books/#{book.id}", headers: { 'Authorization' => "Bearer #{token}" }
              expect(response).to have_http_status(:unprocessable_content)
              expect(response.body).to include("Cannot delete book with active borrowings")
              expect(Book.exists?(book.id)).to be_truthy
            end
          end
        end

        context 'when book does not exist' do
          it 'returns http not found' do
            token = login(user)
            delete "/api/books/9999", headers: { 'Authorization' => "Bearer #{token}" }
            expect(response).to have_http_status(:not_found)
          end
        end
      end

      context 'when user is member' do
        let(:user) { create(:user, role: 'member') }

        it 'returns http forbidden' do
          token = login(user)
          delete "/api/books/#{book.id}", headers: { 'Authorization' => "Bearer #{token}" }
          expect(response).to have_http_status(:forbidden)
          expect(JSON.parse(response.body)).to eq({ 'error' => 'Not authorized' })
          expect(Book.exists?(book.id)).to be_truthy
        end
      end
    end
  end

  def login(user)
    post '/api/login', params: { email: user.email, password: user.password }
    JSON.parse(response.body)['token']
  end
end
