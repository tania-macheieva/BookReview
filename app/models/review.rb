class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :user_id, uniqueness: { scope: :book_id, message: "already reviewed this book" }
end
