require "rails_helper"

RSpec.describe JwtDenylist, type: :model do
  it "is valid with jti and exp" do
    record = JwtDenylist.new(
      jti: SecureRandom.uuid,
      exp: 1.day.from_now
    )

    expect(record).to be_valid
  end

  it "is invalid without jti" do
    record = JwtDenylist.new(exp: 1.day.from_now)

    expect(record).not_to be_valid
  end

  it "is invalid without exp" do
    record = JwtDenylist.new(jti: SecureRandom.uuid)

    expect(record).not_to be_valid
  end
end
