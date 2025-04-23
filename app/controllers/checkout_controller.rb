class CheckoutController < ApplicationController
  def create
    # Ensure the cart is not empty
    if session[:cart].blank?
      redirect_to cart_path, alert: "Your cart is empty."
      return
    end

    # Prepare line items for Stripe Checkout
    line_items = session[:cart].map do |product_id, quantity|
      product = Product.find(product_id)

      {
        price_data: {
          currency: "usd", # Adjust currency as needed
          product_data: {
            name: product.name,
            description: product.description
          },
          unit_amount: (product.price * 100).to_i # Stripe expects amounts in cents
        },
        quantity: quantity
      }
    end

    # Create Stripe Checkout session
    stripe_session = Stripe::Checkout::Session.create(
      payment_method_types: [ "card" ],
      success_url: checkout_success_url,
      cancel_url: checkout_cancel_url,
      mode: "payment",
      line_items: line_items
    )

    # Redirect to Stripe Checkout
    redirect_to stripe_session.url, allow_other_host: true
  end

  def success
    # Handle successful payment
    if session[:cart].present?
      create_order_from_cart # Create the order and save it to the database
      session[:cart] = {} # Clear the cart after successful payment
      flash[:notice] = "Payment successful! Thank you for your purchase."
    else
      flash[:alert] = "No items in the cart to process the order."
    end

    redirect_to orders_path # Redirect to the orders page
  end

  def cancel
    # Handle canceled payment
    flash[:alert] = "Payment canceled. Please try again."
    redirect_to cart_path
  end

  private

  def create_order_from_cart
    # Create a new order for the current user
    order = current_user.orders.create!(
      total_price: calculate_cart_total,
      status: "completed"
    )

    # Add each cart item to the order
    session[:cart].each do |product_id, quantity|
      product = Product.find(product_id)
      order.order_items.create!(
        product: product,
        quantity: quantity,
        price: product.price
      )
    end
  end

  def calculate_cart_total
    session[:cart].sum do |product_id, quantity|
      product = Product.find(product_id)
      product.price * quantity
    end
  end
end
