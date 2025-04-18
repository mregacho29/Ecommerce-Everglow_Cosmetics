class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end


  def search
    @query = params[:query]
    @products = Product.where('name ILIKE ?', "%#{@query}%")
    render :index
  end

  def stores
  end

  def services
  end
end