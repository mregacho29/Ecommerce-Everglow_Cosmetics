class ProductsController < ApplicationController
  def index
    # Start with all products
    @products = Product.all

    # Filter by category if present
    if params[:category].present?
      category = Category.where("LOWER(name) = ?", params[:category].downcase).first
      if category.present?
        @products = category.products
        # Fetch only the first 5 tags dynamically for the selected category with product counts
        @tags = Tag.joins(:products)
                   .where(products: { category_id: category.id })
                   .distinct
                   .limit(5)
                   .select("tags.name, COUNT(products.id) AS product_count")
                   .group("tags.id")
      else
        @products = Product.none
        @tags = [] # No tags if the category doesn't exist
      end
    else
      # Fetch only the first 5 tags if no category is selected with product counts
      @tags = Tag.joins(:products)
                 .distinct
                 .limit(5)
                 .select("tags.name, COUNT(products.id) AS product_count")
                 .group("tags.id")
    end

    # Filter by tag if present
    if params[:tag].present?
      @products = @products.joins(:tags).where(tags: { name: params[:tag] })
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
