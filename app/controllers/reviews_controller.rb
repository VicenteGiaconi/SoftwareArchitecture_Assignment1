class ReviewsController < ApplicationController
    before_action :set_review, only: [:show, :edit, :update, :destroy]

    def index
      if params[:q].present?
        if Review.respond_to?(:search)
          @reviews = Review.search(params[:q], page: params[:page], per_page: 15)
        else
          words = params[:q].split
          query = words.map { |w| "review ILIKE ?" }.join(" OR ")
          values = words.map { |w| "%#{w}%" }
          @reviews = Review.where(query, *values).page(params[:page]).per(15)
        end
      else
        @reviews = Review.page(params[:page]).per(15)
      end
    end

    def show
    end

    def new
        @review = Review.new
        @books = Book.all
    end

    def create
        @review = Review.new(review_params)
        if @review.save
            redirect_to @review, notice: 'The review was successfully created.'
        else
            render :new
        end
    end

    def edit
        @edit = true
    end

    def update
        if @review.update(review_params)
            redirect_to @review, notice: 'The review was successfully updated.'
        else
            render :edit
        end
    end

    def destroy
        @review.destroy
        redirect_to reviews_url, notice: 'The review was successfully deleted.'
    end

    private
        def set_review
            @review = Review.find(params[:id])
        end

        def review_params
            params.require(:review).permit(:review, :score, :number_of_up_votes, :book_id)
        end
            
end
