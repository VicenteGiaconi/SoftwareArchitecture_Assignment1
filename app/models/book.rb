class Book < ApplicationRecord
  has_one_attached :cover_image

  searchkick
  belongs_to :author
  # according to the instructions.
  has_many :reviews, dependent: :destroy
  has_many :sales, dependent: :destroy
  
  after_save :clear_caches
  after_destroy :clear_caches

  def clear_caches
    Rails.cache.delete('top_10_rated_books_with_reviews') rescue nil
    Rails.cache.delete('top_50_sales_with_details') rescue nil
  end

  def search_data
    {
      name: name,
      summary: summary
    }
  end
end