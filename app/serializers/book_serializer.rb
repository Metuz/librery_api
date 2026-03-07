class BookSerializer < BaseSerializer
  attributes :id, :title, :author 

  has_many :genres
end
