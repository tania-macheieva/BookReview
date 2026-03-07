class BooksController < ApplicationController
  before_action :set_book, only: [:show, :update, :destroy]
  skip_before_action :authenticate_request, only: [:index, :show]

  # GET /books
  def index
    cache_key = "books_index_#{params[:page]}_#{params[:per_page]}_#{params[:search]}_#{params[:sortBy]}_#{params[:order]}"
    books = Rails.cache.fetch(cache_key, expires_in: 10.minutes) do
      BooksQuery.new(params).call
    end

    # HTTP caching
    if stale?(books, last_modified: books.maximum(:updated_at))
      render json: books
    end
  end

  # GET /books/:id
  def show
    if stale?(@book, last_modified: @book.updated_at)
      render json: @book.as_json(include: :reviews)
    end
  end

  # POST /books
  def create
    book = Book.new(book_params)
    book.user = current_user
    if book.save
      Rails.cache.delete_matched("books_index_*") # Очищаємо кеш списку
      render json: book, status: :created
    else
      render json: book.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /books/:id
  def update
    if @book.update(book_params)
      Rails.cache.delete_matched("books_index_*")
      render json: @book
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # DELETE /books/:id
  def destroy
    @book.destroy
    Rails.cache.delete_matched("books_index_*")
    head :no_content
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :description)
  end
end