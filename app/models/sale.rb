class Sale < ApplicationRecord
  belongs_to :book

  after_save :clear_sales_cache
  after_destroy :clear_sales_cache

  def clear_sales_cache
    Rails.cache.delete('sales_index')
  end
end