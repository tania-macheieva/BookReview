class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :rating,
            presence: true,
            numericality: { greater_than_or_equal_to: 1,
                            less_than_or_equal_to: 5 }

  validates :user_id,
            uniqueness: { scope: :book_id,
                          message: "already reviewed this book" }
end
