class Book < ApplicationRecord
  belongs_to :genre
  belongs_to :author
  has_many   :borrowings

  validates :title, :isbn, presence: true
  validates :isbn, uniqueness: true
  validates :total_copies, numericality: { only_integer: true }
end
