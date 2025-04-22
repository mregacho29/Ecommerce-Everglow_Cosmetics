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
    flash[:notice] = "Payment successful! Thank you for your purchase."
    session[:cart] = {} # Clear the cart after successful payment
    redirect_to root_path
  end

  def cancel
    # Handle canceled payment
    flash[:alert] = "Payment canceled. Please try again."
    redirect_to cart_path
  end
end
