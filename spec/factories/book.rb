FactoryBot.define do
  factory :book do
    title        { 'Sample Book' }
    isbn         { '1234567890' }
    author       { create(:author) }
    genre        { create(:genre) }
  end
end
