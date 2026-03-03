class AddAverageRatingToBooks < ActiveRecord::Migration[8.1]
  def change
    add_column :books, :average_rating, :float
    add_index :books, :average_rating
  end
end
