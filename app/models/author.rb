class Author < ApplicationRecord
  validates :name, presence: true, uniqueness: true
  has_many :books, dependent: :destroy
end