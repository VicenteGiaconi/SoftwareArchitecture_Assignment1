class Author < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :books, dependent: :destroy

  after_save :clear_author_cache
  after_destroy :clear_author_cache

  def clear_author_cache
    Rails.cache.delete_matched("authors_index_*")
  end
end