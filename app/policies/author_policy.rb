class AuthorPolicy < ApplicationPolicy
  def index?
    user.librarian?
  end
end
