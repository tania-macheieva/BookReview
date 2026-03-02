class ReviewsController < ApplicationController
  before_action :set_review, only: [:update, :destroy]
  before_action :set_book, only: [:index, :create]

  def index
    reviews = @book.reviews
    render json: reviews
  end

  def create
    # review.user = current_user
    @review = @book.reviews.build(review_params)
    @review.user_id = 1
    if @review.save
      render json: @review, status: :created
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  def update
    if @review.update(review_params)
      render json: @review
    else
      render json: @review.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @review.destroy
    head :no_content
  end

  private

  def set_review
    @review = Review.find(params[:id])
  end

  def set_book
    @book = Book.find(params[:book_id])
  end

  def review_params
    params.require(:review).permit(:rating, :comment)
  end
end
