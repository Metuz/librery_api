require 'rails_helper'

RSpec.describe Genre, type: :model do
  let(:genre) { create(:genre) }

  subject { genre }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }
end
