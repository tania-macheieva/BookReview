class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy

  def as_json(options = {})
    super(
      only: [ :id, :title, :author, :description ],
      methods: [ :average_rating, :reviews_count ],
      include: {
        reviews: {
          only: [ :id, :rating, :comment ],
          include: {
            user: { only: [ :id, :username ] }
          }
        }
      }
    )
  end

  def average_rating
    reviews.any? ? reviews.average(:rating).to_f : 0.0
  end

  def reviews_count
    reviews.size
  end
end
