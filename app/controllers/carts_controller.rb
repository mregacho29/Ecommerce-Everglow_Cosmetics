class CartsController < ApplicationController
  def show
    @cart = session[:cart] || {}
  end

  def add
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    session[:cart] ||= {}
    session[:cart][product_id] ||= 0
    session[:cart][product_id] += quantity

    redirect_to cart_path, notice: "Product added to cart!"
  end

  def remove
    product_id = params[:product_id]
    session[:cart].delete(product_id) if session[:cart]

    redirect_to cart_path, notice: "Product removed from cart!"
  end


  def checkout
    @cart = session[:cart] || {}
  end
end
