class ProductsController < ApplicationController
  def index
    @products = Product.all
  end

  def show
    @product = Product.find(params[:id])
  end


  def search
    if params[:query].present?
      @products = Product.where("LOWER(name) LIKE ?", "%#{params[:query].downcase}%")
    else
      @products = Product.all
    end
    render :index
  end

  def stores
  end

  def services
  end
end