class Review < ApplicationRecord
  searchkick
  belongs_to :book
  
	after_save :clear_review_cache
  after_destroy :clear_review_cache

  def clear_review_cache
    Rails.cache.delete('reviews_index') rescue nil
  end

  def search_data
    {
      review: review,
      score: score
    }
  end
end