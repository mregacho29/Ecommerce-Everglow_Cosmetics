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

    if @cart.empty?
      redirect_to cart_path, alert: "Your cart is empty. Add items to proceed to checkout."
      return
    end

    # Fetch products and calculate totals
    @products = Product.find(@cart.keys.map(&:to_i))
    @total_price = @products.sum do |product|
      quantity = @cart[product.id.to_s].to_i
      product.price * quantity
    end

    # Prepare order summary (optional)
    @order_summary = @products.map do |product|
      quantity = @cart[product.id.to_s].to_i
      {
        name: product.name,
        quantity: quantity,
        price: product.price,
        total: product.price * quantity
      }
    end
  end
end
