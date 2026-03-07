FactoryBot.define do
  factory :book_genre do
    book { create(:book) }
    genre { create(:genre) }
  end
end
