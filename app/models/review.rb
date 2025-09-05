class Review < ApplicationRecord
  searchkick
  belongs_to :book

  def search_data
    {
      review: review,
      score: score
    }
  end
end