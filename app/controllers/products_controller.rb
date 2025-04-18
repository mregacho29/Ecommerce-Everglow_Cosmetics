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

    # Filter by "on sale" (price below 50)
    if params[:filter] == "on_sale"
      @products = @products.where("price < ?", 50)
    end

    # Paginate the results
    @products = @products.page(params[:page]).per(9)
  end


  def show
    @product = Product.find(params[:id])
  end


  def search
    @products = Product.all

    # Search by keyword in name or description
    if params[:query].present?
      query = params[:query].downcase
      @products = @products.where("LOWER(name) LIKE ? OR LOWER(description) LIKE ?", "%#{query}%", "%#{query}%")
    end

    # Filter by category if provided
    if params[:category].present?
      category = Category.where("LOWER(name) = ?", params[:category].downcase).first
      @products = category.present? ? @products.where(category_id: category.id) : Product.none
    end

    # Paginate the results
    @products = @products.page(params[:page]).per(9)

    render :index
  end

  def stores
  end

  def services
  end
end
