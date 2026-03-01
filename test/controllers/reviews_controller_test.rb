require "test_helper"

class ReviewsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:one)
    @review = reviews(:one)
  end

  test "should get index" do
    get book_reviews_url(@book)
    assert_response :success
  end

  test "should create review" do
    assert_difference("Review.count") do
      post book_reviews_url(@book), params: {
        review: { rating: 5, comment: "Great!" }
      }
    end
    assert_response :created
  end

  test "should update review" do
    patch review_url(@review), params: {
      review: { rating: 4, comment: "Actually, it was okay." }
    }, as: :json
    assert_response :success
  end

  test "should destroy review" do
    assert_difference("Review.count", -1) do
      delete review_url(@review), as: :json
    end
    assert_response :no_content
  end
end
