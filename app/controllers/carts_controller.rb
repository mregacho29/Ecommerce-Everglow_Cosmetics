class CartsController < ApplicationController
  def show
    @cart = session[:cart] || {}
  end

  def add
    product = Product.find(params[:product_id])
    quantity = params[:quantity].to_i

    session[:cart] ||= {}
    session[:cart][product.id.to_s] ||= 0
    session[:cart][product.id.to_s] += quantity

    flash[:notice] = "#{product.name} has been added to your cart."
    redirect_to products_path
  end

  def remove
    product_id = params[:product_id]
    session[:cart].delete(product_id) if session[:cart]

    redirect_to cart_path, notice: "Product removed from cart!"
  end

  def shipping
    @shipping_info = session[:shipping_info] || {}
  end

def save_shipping
  session[:shipping_info] = params[:shipping_info]
  redirect_to cart_path, notice: "Shipping information saved. Proceeding to checkout."
end

  def checkout
    @cart = session[:cart] || {}

    if @cart.empty?
      redirect_to cart_path, alert: "Your cart is empty. Add items to proceed to checkout."
      return
    end

    if user_signed_in?
      if current_user.address.present?
        @shipping_info = current_user.address
      else
        redirect_to new_address_path, alert: "Please add your shipping information before proceeding to checkout."
        return
      end
    else
      @shipping_info = session[:shipping_info]
      if @shipping_info.blank?
        redirect_to shipping_carts_path, alert: "Please provide your shipping information before proceeding to checkout."
        return
      end
    end

    # Fetch products and calculate totals
    @products = Product.find(@cart.keys.map(&:to_i))
    @total_price = @products.sum do |product|
      quantity = @cart[product.id.to_s].to_i
      product.price * quantity
    end

    # Create a Stripe Checkout Session
    session = Stripe::Checkout::Session.create(
      payment_method_types: [ "card" ],
      line_items: @products.map do |product|
        {
          price_data: {
            currency: "usd",
            product_data: {
              name: product.name
            },
            unit_amount: (product.price * 100).to_i # Stripe expects amounts in cents
          },
          quantity: @cart[product.id.to_s].to_i
        }
      end,
      mode: "payment",
      success_url: checkout_success_url,
      cancel_url: checkout_cancel_url
    )

    # Redirect to Stripe Checkout
    redirect_to session.url, allow_other_host: true
  end
end
