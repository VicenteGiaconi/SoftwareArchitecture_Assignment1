class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    if params[:q].present?
      if Book.respond_to?(:search)
        @books = Book.search(params[:q], page: params[:page], per_page: 15)
      else
        words = params[:q].split
        query = words.map { |w| "summary ILIKE ?" }.join(" OR ")
        values = words.map { |w| "%#{w}%" }
        @books = Book.where(query, *values).page(params[:page]).per(15)
      end
    else
      @books = Book.page(params[:page]).per(15)
    end
  end

  def show
  end

  def new
    @book = Book.new
    @authors = Author.all 
  end

  def edit
    @authors = Author.all 
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to @book, notice: 'The book was created succesfuly.'
    else
      @authors = Author.all 
      render :new
    end
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'The book was updated succesfuly.'
    else
      @authors = Author.all 
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_url, notice: 'The book was deleted succesfuly.'
  end

  def top10
    cache_key = 'top_10_rated_books_with_reviews'
    @top_books = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      books = Book
        .left_joins(:reviews)
        .group('books.id')
        .order('AVG(reviews.score) DESC NULLS LAST')
        .limit(10)
        .includes(:reviews)

      # Obtiene las reseñas más votadas para cada libro
      books.map do |book|
        highest_rated_review = book.reviews.order(score: :desc, number_of_up_votes: :desc).first
        lowest_rated_review = book.reviews.order(score: :asc, number_of_up_votes: :desc).first
        
        {
          book: book,
          highest_rated_review: highest_rated_review,
          lowest_rated_review: lowest_rated_review
        }
      end
    end
  end

  def top50_sales
    cache_key = 'top_50_sales_with_details'
    @top_books = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      Book.left_joins(:sales)
          .select('books.*, COALESCE(SUM(sales.sales), 0) AS total_book_sales')
          .group('books.id')
          .order('total_book_sales DESC')
          .limit(50)
          .includes(:author, :sales)
    end

    author_sales = Sale.group(:book_id).sum(:sales)
    @author_totals =
      Book.joins(:sales)
          .group(:author_id)
          .sum('sales.sales')

    @top5_by_year = {}
    Sale.select(:year).distinct.each do |sale|
      @top5_by_year[sale.year] = Sale.where(year: sale.year)
                                    .group(:book_id)
                                    .sum(:sales)
                                    .sort_by { |_, v| -v }
                                    .first(5)
                                    .map(&:first)
    end
  end

  private
    def set_book
      @book = Book.find(params[:id])
    end

    def book_params
      params.require(:book).permit(:name, :summary, :date_of_publication, :number_of_sales, :author_id, :cover_image)
    end
end