require 'rails_helper'

RSpec.describe BorrowingPolicy, type: :policy do
  let(:user) { create(:user, role: role) }

  subject { described_class }

  permissions :create? do
    context 'when user is librarian' do
      let(:role) { :librarian }

      it 'allows access' do
        expect(subject).to permit(user, Borrowing)
      end
    end
    
    context 'when user is member' do
      let(:role) { :member }

      it 'allows access' do
        expect(subject).to permit(user, Borrowing)
      end
    end
  end

  permissions :return_book? do
    context 'when user is librarian' do
      let(:role) { :librarian }

      it 'allows access' do
        expect(subject).to permit(user, Borrowing)
      end
    end
    
    context 'when user is member' do
      let(:role) { :member }

      it 'allows access' do
        expect(subject).to permit(user, Borrowing)
      end
    end
  end
end
