FactoryBot.define do
  factory :genre do
    sequence(:name) do |n|
      "genre-#{n}"
    end
  end
end
