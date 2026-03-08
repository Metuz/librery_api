FactoryBot.define do
  factory :book do
    title        { Faker::Book.title }
    author       { create(:author) }
    sequence(:isbn) do |n|
      "1232#{n}"
    end

    after(:create) do |book|
      genre = create(:genre)
      book.genres << genre
    end
  end
end
