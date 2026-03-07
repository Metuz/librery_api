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
end
