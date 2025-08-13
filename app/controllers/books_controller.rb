class BooksController < ApplicationController
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.all
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
      redirect_to @book, notice: 'El libro fue creado exitosamente.'
    else
      @authors = Author.all 
      render :new
    end
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'El libro fue actualizado exitosamente.'
    else
      @authors = Author.all 
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_url, notice: 'El libro fue eliminado exitosamente.'
  end

  def top10
    @top_books = Book
      .left_joins(:reviews)
      .group('books.id')
      .order('AVG(reviews.score) DESC NULLS LAST')
      .limit(10)
      .includes(:reviews)
  end

  def top50_sales
    @top_books = Book
      .left_joins(:sales)
      .select('books.*, COALESCE(SUM(sales.sales), 0) AS total_book_sales')
      .group('books.id')
      .order('total_book_sales DESC')
      .limit(50)
      .includes(:author, :sales)

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
      params.require(:book).permit(:name, :summary, :date_of_publication, :number_of_sales, :author_id)
    end
end