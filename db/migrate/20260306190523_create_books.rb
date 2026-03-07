class CreateBooks < ActiveRecord::Migration[7.2]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :isbn, null: false
      t.integer :total_copies, null: false, default: 1
      t.references :author, null: false, foreign_key: true

      t.timestamps
    end
  end
end
