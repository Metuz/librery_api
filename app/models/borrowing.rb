class Borrowing < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :book_id, :borrowed_at, presence: true
  validate :book_available, :same_book_borrowed_by_user, on: :create
  before_create :set_due_date

  scope :librarian_dashboard, lambda {
    result = find_by_sql([
      'SELECT COUNT(DISTINCT id) AS total_books_borrowed,
              COUNT(*) FILTER (WHERE returned_at IS NULL AND due_date < ?) AS overdue_books
      FROM borrowings',
      Date.today
    ]).first

    {
      total_books_borrowed: result.total_books_borrowed,
      overdue_books: result.overdue_books
    }
  }

  scope :member_dashboard, ->(user_id) {
    joins(:book).
      where(user_id: user_id).
      select('borrowings.*, books.title AS book_title')
  }

  def return
    self.returned_at = Date.today
    save
  end

  private

  def book_available
    return if book.total_copies > book.borrowings.where(returned_at: nil).count

    errors.add(:book, "is not available for borrowing")
  end

  def same_book_borrowed_by_user
    return unless user.borrowings.where(book: book, returned_at: nil).exists?

    errors.add(:user, "cannot borrow the same book multiple times without returning it first")
  end

  def set_due_date
    self.due_date = borrowed_at + 14.days
  end
end
