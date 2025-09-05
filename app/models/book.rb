class Book < ApplicationRecord
  has_one_attached :cover_image

  belongs_to :author
  # according to the instructions.
  has_many :reviews, dependent: :destroy
  has_many :sales, dependent: :destroy
  
  after_save :clear_caches
  after_destroy :clear_caches

  def clear_caches
    Rails.cache.delete('top_10_rated_books_with_reviews')
    Rails.cache.delete('top_50_sales_with_details')
  end
end