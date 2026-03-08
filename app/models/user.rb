class User < ApplicationRecord
  devise :database_authenticatable,
         :registerable,
         :jwt_authenticatable,
         jwt_revocation_strategy: JwtDenylist

  has_many :borrowings

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :password, length: { minimum: 6 }, if: -> { password.present? }

  enum role: { librarian: 0, member: 1 }

  scope :members_with_overdue_borrowings, -> {
    joins(:borrowings)
      .where('borrowings.due_date < ? AND borrowings.returned_at IS NULL', Date.today)
      .where(role: :member)
      .distinct
      .select('users.name, users.id')
  }
end
