class Book < ApplicationRecord
  has_many :book_genres, dependent: :delete_all
  has_many :genres, through: :book_genres
  belongs_to :author
  has_many   :borrowings

  validates :title, :isbn, presence: true
  validates :isbn, uniqueness: true
  validates :total_copies, numericality: { only_integer: true }

  before_destroy :check_borrowings

  private

  def check_borrowings
    if borrowings.where(returned_at: nil).exists?
      errors.add(:base, "Cannot delete book with active borrowings")
      throw(:abort)
    end
  end
end
