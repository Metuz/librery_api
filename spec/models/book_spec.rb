require 'rails_helper'

RSpec.describe Book, type: :model do
  let(:book) { create(:book) }

  subject { book }

  it { is_expected.to validate_presence_of(:title) }
  it { is_expected.to validate_presence_of(:isbn) }
  it { is_expected.to validate_uniqueness_of(:isbn) }
  it { is_expected.to validate_numericality_of(:total_copies).only_integer }
  it { is_expected.to belong_to(:author) }
  it { is_expected.to belong_to(:genre) }
end
