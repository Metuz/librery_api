FactoryBot.define do
  factory :jwt_denylist do
    jti { "MyString" }
    exp { "2026-03-06 17:31:34" }
  end
end
