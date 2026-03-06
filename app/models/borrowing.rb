class Borrowing < ApplicationRecord
  belongs_to :book

  validates :book_id, :borrowed_at, presence: true
  validate :book_available, on: :create
  before_create :set_due_date

  private

  def book_available
    return if book.total_copies > book.borrowings.where(returned_at: nil).count
    errors.add(:book, "is not available for borrowing")
  end

  def set_due_date
    self.due_date = borrowed_at + 14.days
  end
end
