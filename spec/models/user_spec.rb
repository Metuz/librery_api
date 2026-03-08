require "rails_helper"

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  subject { user }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:email) }
  it { is_expected.to validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { is_expected.to validate_length_of(:password).is_at_least(6) }
  it { is_expected.to have_many(:borrowings) }

  context "when role is librarian" do
    it "is a librarian" do
      expect(user.librarian?).to be true
    end
  end

  context "when role is member" do
    let(:user) { create(:user, role: :member) }

    it "is a member" do
      expect(user.member?).to be true
    end
  end

  context "enums" do
    it { should define_enum_for(:role).with_values(librarian: 0, member: 1) }
  end

  describe "devise modules" do
    it "includes database authenticatable module" do
      expect(User.devise_modules).to include(:database_authenticatable)
    end

    it "includes registerable module" do
      expect(User.devise_modules).to include(:registerable)
    end

    it "includes jwt_authenticatable module" do
      expect(User.devise_modules).to include(:jwt_authenticatable)
    end
  end

  describe "jwt configuration" do
    it "uses JwtDenylist as revocation strategy" do
      strategy = User.jwt_revocation_strategy
      expect(strategy).to eq(JwtDenylist)
    end
  end

  describe '#members_with_overdue_borrowings' do
    let!(:book)                   { create(:book, total_copies: 2) }
    let!(:member_with_overdue)    { create(:user, role: :member) }
    let!(:member_without_overdue) { create(:user, role: :member) }

    before do
      create(:borrowing, book: book, user: member_with_overdue, borrowed_at: 1.month.ago)
      create(:borrowing, book: book, user: member_without_overdue, borrowed_at: 2.weeks.ago, returned_at: 1.week.ago)
    end

    subject { User.members_with_overdue_borrowings }

    it 'returns members with overdue borrowings' do
      result = subject
      expect(result).to include(member_with_overdue)
      expect(result).not_to include(member_without_overdue)
    end
  end
end
