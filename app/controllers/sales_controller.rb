class SalesController < ApplicationController
    before_action :set_review, only: [:show, :edit, :update, :destroy]

    def index
        cache_key = 'sales_index'
        all_sales = Rails.cache.fetch(cache_key, expires_in: 1.hour) do
            Sale.all.to_a
        end
        
        @sales = Kaminari.paginate_array(all_sales).page(params[:page]).per(15)
    end

    def show
    end

    def new
        @sale = Sale.new
        @books = Book.all
    end

    def create
        @sale = Sale.new(sale_params)
        if @sale.save
            redirect_to @sale, notice: 'The sale was successfully created.'
        else
            render :new
        end
    end

    def edit
        @books = Book.all
    end

    def update
        if @sale.update(sale_params)
            redirect_to @sale, notice: 'The sale was successfully updated.'
        else
            render :edit
        end
    end

    def destroy
        @sale.destroy
        redirect_to sales_url, notice: 'The sale was successfully deleted.'
    end

    private

    def set_review
        @sale = Sale.find(params[:id])
    end

    def sale_params
        params.require(:sale).permit(:book_id, :sales, :year)
    end
end
