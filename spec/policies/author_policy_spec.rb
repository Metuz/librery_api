require 'rails_helper'

RSpec.describe AuthorPolicy, type: :policy do
  let(:user) { create(:user, role: role) }

  subject { described_class }

  permissions :index? do
    context 'when user is librarian' do
      let(:role) { 'librarian' }

      it 'allows access' do
        expect(subject).to permit(user, Author)
      end
    end

    context 'when user is not librarian' do
      let(:role) { 'member' }

      it 'denies access' do
        expect(subject).not_to permit(user, Author)
      end
    end
  end
end
