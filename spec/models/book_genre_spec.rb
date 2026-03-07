require 'rails_helper'

RSpec.describe BookGenre, type: :model do
  let(:book_genre) { create(:book_genre) }

  subject { book_genre }

  it { is_expected.to be_valid }
  it { is_expected.to belong_to(:book) }
  it { is_expected.to belong_to(:genre) }
end
