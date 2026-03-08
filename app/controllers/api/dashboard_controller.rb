class Api::DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    render json: handle_dashboard_data, status: :ok
  end

  private

  def handle_dashboard_data
    return for_librarians if current_user.librarian?

    for_members
  end

  def for_librarians
    borrowings = Borrowing.librarian_dashboard
    members_with_overdue_books = User.members_with_overdue_borrowings
    {
      total_books: Book.count,
      total_books_borrowed: borrowings[:total_books_borrowed],
      overdue_books: borrowings[:overdue_books],
      members_with_overdue_books: members_with_overdue_books
    }
  end

  def for_members
    borrowings = Borrowing.member_dashboard(current_user.id)
    {
      borrowed_books: borrowings.map do |borrowing|
        on_time = borrowing.due_date.after?(Date.today) if borrowing.returned_at.present?
        {
          id: borrowing.id,
          title: borrowing.book_title,
          borrowed_at: borrowing.borrowed_at,
          due_date: borrowing.due_date,
          returned: borrowing.returned_at.present?,
          on_time: on_time
        }
      end
    }
  end
end
