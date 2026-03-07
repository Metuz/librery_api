require 'rails_helper'

RSpec.describe Author, type: :model do
  let(:author) { create(:author) }

  subject { author }

  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to have_many(:books) }
end
