class Api::AuthorsController < ApplicationController
  before_action :authenticate_user!, only: [:index]

  def index
    authors = Author.all
    authorize authors
    render json: AuthorSerializer.new(authors).serializable_hash
  end
end
