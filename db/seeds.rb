# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Cleaning up database..."

require 'faker'
Review.destroy_all
Sale.destroy_all
Book.destroy_all
Author.destroy_all

Faker::Config.locale = 'es'

puts "Creating Authors..."

# authors
authors = []
50.times do
  authors << Author.create(
    name: Faker::Book.author,
    date_of_birth: Faker::Date.birthday(min_age: 10, max_age: 100),
    country_of_origin: Faker::Address.country,
    short_description: Faker::Lorem.paragraph(sentence_count: 2)
  )
end

puts "Creating Books..."

# books
books = []
300.times do
  books << Book.create(
    name: Faker::Book.title,
    summary: Faker::Lorem.paragraph(sentence_count: 5),
    date_of_publication: Faker::Date.between(from: '1900-01-01', to: '2024-01-01'),
    number_of_sales: Faker::Number.between(from: 1000, to: 5000000),
    author: authors.sample 
  )
end

puts "Creating Reviews..."

books.each do |book|
  10.times do
    Review.create(
      review: Faker::Lorem.paragraph(sentence_count: 3),
      score: Faker::Number.between(from: 1, to: 5),
      number_of_up_votes: Faker::Number.between(from: 0, to: 100),
      book: book
    )
  end
end

puts "Creating Sales..."

# sales
books.each do |book|
  pub_year = book.date_of_publication.year
  current_year = 2024
  (pub_year..current_year).each do |year|
    Sale.create(
      year: year,
      sales: Faker::Number.between(from: 100, to: 500_000),
      book: book
    )
  end
end

puts "Done"