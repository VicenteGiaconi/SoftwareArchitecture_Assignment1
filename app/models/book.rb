class Book < ApplicationRecord
  belongs_to :author
  # according to the instructions.
  has_many :reviews, dependent: :destroy
  has_many :sales, dependent: :destroy
  
  #validations
end