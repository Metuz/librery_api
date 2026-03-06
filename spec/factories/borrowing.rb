FactoryBot.define do
  factory :borrowing do
    borrowed_at  { Date.today }
    returned_at  { nil }
  end
end
