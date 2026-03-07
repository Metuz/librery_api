class Book < ApplicationRecord
  has_many :book_genres
  has_many :genres, through: :book_genres
  belongs_to :author
  has_many   :borrowings

  validates :title, :isbn, presence: true
  validates :isbn, uniqueness: true
  validates :total_copies, numericality: { only_integer: true }
end
