class AuthorsController < ApplicationController
  before_action :set_author, only: [:show, :edit, :update, :destroy]

  def index
    @sort_column = params[:sort] || 'name'
    @sort_direction = params[:direction] == 'asc' ? 'asc' : 'desc'
    cache_key = "authors_index_#{@sort_column}_#{@sort_direction}"

    @authors = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
      Author.left_joins(books: [:reviews, :sales])
            .group('authors.id')
            .select(
              'authors.*',
              'COUNT(books.id) AS books_count',
              'AVG(reviews.score) AS average_score',
              'COALESCE(SUM(sales.sales), 0) AS total_sales'
            )
            .order("#{@sort_column} #{@sort_direction}")
    end.page(params[:page]).per(15)
  end

  def show
  end

  def new
    @author = Author.new
  end

  def edit
  end

  def create
    @author = Author.new(author_params)
    if @author.save
      redirect_to @author, notice: 'The authos was created succesfuly.'
    else
      render :new
    end
  end

  def update
    if @author.update(author_params)
      redirect_to @author, notice: 'The author was updated succesfully.'
    else
      render :edit
    end
  end

  def destroy
    @author.destroy
    redirect_to authors_url, notice: 'The author was deleted succesfuly.'
  end

  private
    def set_author
      @author = Author.find(params[:id])
    end

    def author_params
      params.require(:author).permit(:name, :date_of_birth, :country_of_origin, :short_description, :photo)
    end
end