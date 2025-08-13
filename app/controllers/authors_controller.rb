class AuthorsController < ApplicationController
  before_action :set_author, only: [:show, :edit, :update, :destroy]

  def index
    @sort_column = params[:sort] || 'name'
    @sort_direction = params[:direction] == 'asc' ? 'asc' : 'desc'

    authors_with_stats = Author.left_joins(books: [:reviews, :sales])
                               .group('authors.id')
                               .select(
                                 'authors.*', # Selecciona todos los campos del autor
                                 'COUNT(books.id) AS books_count',
                                 'AVG(reviews.score) AS average_score',
                                 'COALESCE(SUM(sales.sales), 0) AS total_sales'
                               )
    
    @authors = authors_with_stats.order("#{@sort_column} #{@sort_direction}")
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
      redirect_to @author, notice: 'El autor fue creado exitosamente.'
    else
      render :new
    end
  end

  def update
    if @author.update(author_params)
      redirect_to @author, notice: 'El autor fue actualizado exitosamente.'
    else
      render :edit
    end
  end

  def destroy
    @author.destroy
    redirect_to authors_url, notice: 'El autor fue eliminado exitosamente.'
  end

  private
    def set_author
      @author = Author.find(params[:id])
    end

    def author_params
      params.require(:author).permit(:name, :date_of_birth, :country_of_origin, :short_description)
    end
end