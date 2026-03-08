class BookSerializer < BaseSerializer
  attributes :id, :title, :isbn, :total_copies, :author, :genres

  attribute :author_name do |object|
    object.author.name
  end

  attribute :genres do |object|
    object.genres.map(&:name)
  end
end
