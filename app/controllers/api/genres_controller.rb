class Api::GenresController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    genres = Genre.all
    authorize genres
    render json: GenreSerializer.new(genres).serializable_hash
  end
end
