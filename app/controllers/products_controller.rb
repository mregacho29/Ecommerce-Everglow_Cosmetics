class ProductsController < ApplicationController
  def index
    @products = Product.all

    if params[:category].present?
      category = Category.where("LOWER(name) = ?", params[:category].downcase).first
      @products = category.present? ? category.products : Product.none
    end

    if params[:filter] == "new"
      @products = @products.where("created_at >= ?", 30.days.ago)
    elsif params[:filter] == "recently_updated"
      @products = @products.where("updated_at >= ?", 30.days.ago)
    end
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
