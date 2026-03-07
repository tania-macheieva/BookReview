class Book < ApplicationRecord
  belongs_to :user, optional: false 
  has_many :reviews, dependent: :destroy

  validates :title, uniqueness: { scope: :user_id, message: ": You already have this book" }

  include PgSearch::Model
  pg_search_scope :search_by_title_and_author,
                  against: [:title, :author],
                  using: { tsearch: { prefix: true } }

  def average_rating
    self[:average_rating] || 0.0
  end

  def reviews_count
    reviews.size
  end
end
