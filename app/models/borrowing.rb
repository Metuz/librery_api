class Borrowing < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :book_id, :borrowed_at, presence: true
  validate :book_available, :same_book_borrowed_by_user, on: :create
  before_create :set_due_date

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
