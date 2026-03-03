class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user

  validates :rating,
            presence: true,
            numericality: { only_integer: true,
                            greater_than_or_equal_to: 1,
                            less_than_or_equal_to: 5 }

  validate :no_duplicate_review

  after_commit :update_book_rating

  def no_duplicate_review
    if Review.exists?(book_id: book_id, user_id: user_id, rating: rating, comment: comment)
      errors.add(:base, "Duplicate review for this book")
    end
  end

  def update_book_rating
    book.update_columns(average_rating: book.reviews.average(:rating).to_f)
  end
end
