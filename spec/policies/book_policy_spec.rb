require 'rails_helper'

RSpec.describe BookPolicy, type: :policy do
  let(:user) { create(:user, role: role) }

  subject { described_class }

  permissions :create? do
    context 'when user is librarian' do
      let(:role) { 'librarian' }

      it 'allows access' do
        expect(subject).to permit(user, Book)
      end
    end

    context 'when user is not librarian' do
      let(:role) { 'member' }

      it 'denies access' do
        expect(subject).not_to permit(user, Book)
      end
    end
  end

  permissions :update? do
    context 'when user is librarian' do
      let(:role) { 'librarian' }

      it 'allows access' do
        expect(subject).to permit(user, Book)
      end
    end

    context 'when user is not librarian' do
      let(:role) { 'member' }

      it 'denies access' do
        expect(subject).not_to permit(user, Book)
      end
    end
  end

  permissions :destroy? do
    context 'when user is librarian' do
      let(:role) { 'librarian' }

      it 'allows access' do
        expect(subject).to permit(user, Book)
      end
    end

    context 'when user is not librarian' do
      let(:role) { 'member' }

      it 'denies access' do
        expect(subject).not_to permit(user, Book)
      end
    end
  end
end
