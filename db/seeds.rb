password = 'password'

# Create librarian
User.create(name: 'Librarian 1', email: 'librarian_1@rails.com', password: password, password_confirmation: password)
User.create(name: 'Librarian 2', email: 'librarian_2@rails.com', password: password, password_confirmation: password)

# Create member
User.create(name: 'Member 1', email: 'member_1@rails.com', password: password, password_confirmation: password)
User.create(name: 'Member 2', email: 'member_2@rails.com', password: password, password_confirmation: password)
User.create(name: 'Member 3', email: 'member_3@rails.com', password: password, password_confirmation: password)

# Create Authors
(1..10).map do
  Author.create(name: Faker::Book.author)
end

# Create Genres
(1..8).map |i| do
  Genre.create(name: "Genre #{i}" )
end

# Create Books
(1..20).map |n| do
  author_id = rand(1..10)
  genre_id = rand(1..8)
  isbn = "1029384756#{n}"
  Book.create(title: Faker::Book.title, author_id: author_id, genre_id: genre_id, total_copies: 20)
end

# Borrowings
member_ids = User.where(role: :member).pluck(:id)

(1..50).map |n| do
  odd = n.odd?
  user_id = member_ids.sample
  book_id = rand(1..20)
  borrowed_at = odd ? 1.week.ago : 3.weeks
  returned_at = odd ? Date.today : nil
  Borrowing.create(book_id: book_id, user_id: user_id, borrowed_at: borrowed_at, returned_at: returned_at )
end

