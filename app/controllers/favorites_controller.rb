class FavoritesController < ApplicationController
  before_action :authenticate_user!, except: :index

  def add
    product = Product.find(params[:product_id])

    if current_user.favorites.exists?(product_id: product.id)
      flash[:notice] = "#{product.name} is already in your favorites."
    else
      current_user.favorites.create(product: product)
      flash[:notice] = "#{product.name} has been added to your favorites."
    end

    redirect_to products_path
  end

  def index
    @favorites = current_user.favorites.includes(:product).page(params[:page]).per(9) # Paginate with 9 products per page
  end

  def remove
    favorite = current_user.favorites.find(params[:id])
    favorite.destroy
    flash[:notice] = "Product has been removed from your favorites."
    redirect_to favorites_path
  end
end
