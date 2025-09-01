class ReviewsController < ApplicationController
    before_action :set_review, only: [:show, :edit, :update, :destroy]

    def index
        cache_key = 'reviews_index'
        all_reviews = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
            Review.all.to_a
        end
        
        @reviews = Kaminari.paginate_array(all_reviews).page(params[:page]).per(15)
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
