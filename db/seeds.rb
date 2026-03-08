password = 'password'

# Create librarian
User.create(name: 'Librarian 1', email: 'librarian_1@rails.com', password: password, password_confirmation: password)
User.create(name: 'Librarian 2', email: 'librarian_2@rails.com', password: password, password_confirmation: password)

# Create member
(1..10).map do |i|
  User.create(name: "Member #{i}", email: "member_#{i}@rails.com", password: password, password_confirmation: password,
              role: 'member')
end

# Create Authors
(1..10).map do
  Author.create(name: Faker::Book.author)
end
author_ids = Author.pluck(:id)

# Create Genres
(1..8).map do |i|
  Genre.create(name: "Genre #{i}" )
end
genre_ids = Genre.pluck(:id)

# Create Books
(1..20).map do |n|
  author_id = author_ids.sample
  genre_id = genre_ids.sample
  isbn = "1029384756#{n}"
  Book.create(title: Faker::Book.title, author_id: author_id, genre_ids: [genre_id], isbn: isbn, total_copies: 20)
end
book_ids = Book.pluck(:id)
book_size = book_ids.size

# Borrowings
member_ids = User.where(role: :member).pluck(:id)
first_member_id = member_ids.sort.first
last_member_id = member_ids.sort.last

(1..50).map do |n|
  odd = n.odd?
  user_id = member_ids[rand(1..member_ids.size - 1)]
  book_id = book_ids[rand(1..book_size -1)]
  borrowed_at = odd ? 1.week.ago : 3.weeks.ago
  returned_at = odd ? Date.today : nil
  # This might will fails on some cases because of the validation in Borrowing model, but it's just for seeding data,
  # so we can ignore it.
  Borrowing.create(book_id: book_id, user_id: user_id, borrowed_at: borrowed_at, returned_at: returned_at )
end

