require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  let(:book)      { create(:book, total_copies: 2) }
  let(:borrowing) { create(:borrowing, book: book) }

  subject { borrowing }

  it { is_expected.to belong_to(:book) }
  it { is_expected.to validate_presence_of(:borrowed_at) }

  context 'when book is available' do
    it 'is valid' do
      expect(borrowing).to be_valid
    end
  end

  context 'when book is not available' do
    before do
      create(:borrowing, book: book)
      create(:borrowing, book: book)
    end

    it 'should raise an error' do
      expect { borrowing }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
