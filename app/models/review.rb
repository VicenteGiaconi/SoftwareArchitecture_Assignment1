class Review < ApplicationRecord
  belongs_to :book
  
	after_save :clear_review_cache
  after_destroy :clear_review_cache

  def clear_review_cache
    Rails.cache.delete('reviews_index')
  end
end