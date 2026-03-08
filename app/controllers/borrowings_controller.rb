class BorrowingsController < ApplicationController
  before_action :authenticate_user!, only: [:create, :return_book, :by_user]

  def create
    borrowing = Borrowing.new(borrowing_params)
    borrowing.user = current_user
    authorize borrowing
    if borrowing.save
      render json: { message: 'Borrowing created successfully' }, status: :created
    else
      render json: { errors: borrowing.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def return_book
    borrowing = Borrowing.find_by(id: params[:id], returned_at: nil)
    return render json: { error: 'Borrowing not found or already returned' }, status: :not_found unless borrowing

    authorize borrowing
    borrowing.return
    if borrowing
      render json: { message: 'Book returned successfully' }, status: :ok
    else
      render json: { errors: borrowing.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def borrowing_params
    params.require(:borrowing).permit(:book_id, :borrowed_at)
  end
end
