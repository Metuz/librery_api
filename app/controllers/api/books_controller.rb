class Api::BooksController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  def index
    books = Book.includes(:genres, :author).all
    render json: BookSerializer.new(books).serializable_hash
  end

  def create
    book = Book.new(book_params)
    authorize book
    if book.save
      render json: { message: 'Book created successfully' }, status: :created
    else
      render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    book = set_book
    authorize book
    if book.update(book_params)
      render json: { message: 'Book updated successfully' }, status: :ok
    else
      render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    book = set_book
    return render json: { error: 'Book not found' }, status: :not_found unless book

    authorize book
    if book.destroy
      render json: { message: 'Book deleted successfully' }, status: :ok
    else
      render json: { errors: book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :isbn, :author_id, genre_ids: [])
  end

  def set_book
    Book.find(params[:id])
  end
end
