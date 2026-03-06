class CreateBorrowings < ActiveRecord::Migration[7.2]
  def change
    create_table :borrowings do |t|
      t.references :book, null: false, foreign_key: true
      t.date :borrowed_at
      t.date :due_date
      t.date :returned_at

      t.timestamps
    end
  end
end
