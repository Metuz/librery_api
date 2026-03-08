require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  let(:user)      { create(:user) }
  let(:book)      { create(:book, total_copies: 2) }
  let(:borrowing) { create(:borrowing, book: book, user: user) }

  subject { borrowing }

  it { is_expected.to belong_to(:book) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:borrowed_at) }

  context 'when book is available' do
    it 'is valid' do
      expect(borrowing).to be_valid
    end
  end

  context 'when book is not available' do
    before do
      user_1 = create(:user)
      user_2 = create(:user)
      create(:borrowing, book: book, user: user_1)
      create(:borrowing, book: book, user: user_2)
    end

    it 'should raise an error' do
      expect { borrowing }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  context 'user can not borrow the same book multiple times' do
    before do
      create(:borrowing, book: book, user: user)
    end

    it 'should raise an error' do
      expect { borrowing }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe '#librarian_dashboard' do
    let!(:book)               { create(:book, total_copies: 2) }
    let!(:user_1)             { create(:user) }
    let!(:user_2)             { create(:user) }
    let!(:borrowings)         { create(:borrowing, book: book, user: user_1) }
    let!(:overdue_borrowing)  { create(:borrowing, book: book, user: user_2, borrowed_at: 3.weeks.ago) }

    subject { Borrowing.librarian_dashboard }

    it 'returns total books borrowed and overdue books' do
      result = subject
      expect(result[:total_books_borrowed]).to eq(2)
      expect(result[:overdue_books]).to eq(1)
    end
  end

  describe '#member_dashboard' do
    let!(:user)       { create(:user) }
    let!(:book_1)     { create(:book, total_copies: 2) }
    let!(:book_2)     { create(:book, total_copies: 2) }
    let!(:borrowing_1) { create(:borrowing, book: book_1, user: user, borrowed_at: 1.week.ago, returned_at: 2.days.ago) }
    let!(:borrowing_2) { create(:borrowing, book: book_2, user: user) }

    subject { Borrowing.member_dashboard(user.id) }

    it 'returns borrowings for the given user' do
      result = subject
      expect(result.first.book_title).to eq(book_1.title)
      expect(result.second.book_title).to eq(book_2.title)
      expect(result.second.borrowed_at).to eq(borrowing_2.borrowed_at)
    end
  end
end
