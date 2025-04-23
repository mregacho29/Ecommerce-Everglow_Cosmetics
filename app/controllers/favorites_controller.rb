class FavoritesController < ApplicationController
  before_action :authenticate_user! # Ensure only authenticated users can access these actions

  def add
    product = Product.find(params[:product_id])

    # Add the product to the user's favorites
    if current_user.favorites.exists?(product_id: product.id)
      flash[:notice] = "#{product.name} is already in your favorites."
    else
      current_user.favorites.create(product: product)
      flash[:notice] = "#{product.name} has been added to your favorites."
    end

    redirect_to products_path
  end

  def index
    # Display the user's favorite products
    @favorites = current_user.favorites.includes(:product)
  end
end
