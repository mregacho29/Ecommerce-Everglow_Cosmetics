class ProductsController < ApplicationController
  def index
    @products = Product.all

    # Filter by category if present
    if params[:category].present?
      category = Category.where("LOWER(name) = ?", params[:category].downcase).first
      @products = category.present? ? category.products : Product.none
    end

    # Filter by "new" or "recently updated" if present
    if params[:filter] == "new"
      @products = @products.where("created_at >= ?", 3.days.ago).order(created_at: :desc)
    elsif params[:filter] == "recently_updated"
      @products = @products.where("updated_at >= ?", 3.days.ago).order(updated_at: :desc)
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
