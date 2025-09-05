class Book < ApplicationRecord
  searchkick
  belongs_to :author
  # according to the instructions.
  has_many :reviews, dependent: :destroy
  has_many :sales, dependent: :destroy
  
  #validations

  def search_data
    {
      name: name,
      summary: summary
    }
  end
end