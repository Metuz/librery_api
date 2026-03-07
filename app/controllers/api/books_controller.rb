class Api::BooksController < ApplicationController
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  def index
    books = Book.includes(:genres).all
    render json: BookSerializer.new(books).serializable_hash
  end

  def create
  end

  def update
  end

  def destroy
  end
end
