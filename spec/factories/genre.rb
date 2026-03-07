FactoryBot.define do
  factory :genre do
    name { Faker::Book.unique.genre }
  end
end
