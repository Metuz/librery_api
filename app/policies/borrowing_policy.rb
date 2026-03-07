class BorrowingPolicy < ApplicationPolicy
  def create?
    user.librarian? || user.member?
  end

  def return_book?
    user.librarian? || user.member?
  end
end
