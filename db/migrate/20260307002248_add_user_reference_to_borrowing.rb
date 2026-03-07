class AddUserReferenceToBorrowing < ActiveRecord::Migration[7.2]
  def change
    add_reference :borrowings, :user, null: false, foreign_key: true
  end
end
