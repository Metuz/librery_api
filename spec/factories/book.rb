FactoryBot.define do
  factory :book do
    title        { Faker::Book.title }
    isbn         { Faker::Code.isbn }
    author       { create(:author) }

    after(:create) do |book|
      genre = create(:genre)
      book.genres << genre
    end
  end
end
