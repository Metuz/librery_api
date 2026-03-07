class BorrowingSerializer < BaseSerializer
  attributes :id, :borrowed_at, :due_date, :returned_at

  belongs_to :book
end
