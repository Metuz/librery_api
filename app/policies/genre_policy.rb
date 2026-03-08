class GenrePolicy < ApplicationPolicy
  def index?
    user.librarian?
  end
end
