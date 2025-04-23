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
          currency: "cad", # Adjust currency as needed
          product_data: {
            name: product.name,
            description: product.description
          },
          unit_amount: (product.price * 100).to_i # Stripe expects amounts in cents
        },
        quantity: quantity
      }
    end

    # Calculate tax and add it as a separate line item
    tax = calculate_tax
    line_items << {
      price_data: {
        currency: "cad",
        product_data: {
          name: "Tax (GST + PST)"
        },
        unit_amount: (tax * 100).to_i # Stripe expects amounts in cents
      },
      quantity: 1
    }

    # Create Stripe Checkout session
    stripe_session = Stripe::Checkout::Session.create(
      payment_method_types: [ "card" ],
      success_url: "#{checkout_success_url}?session_id={CHECKOUT_SESSION_ID}", # Include session_id for success action
      cancel_url: checkout_cancel_url,
      mode: "payment",
      line_items: line_items
    )

    # Redirect to Stripe Checkout
    redirect_to stripe_session.url, allow_other_host: true
  end


  def success
    if session[:cart].present?
      if user_signed_in?
        # Calculate total and tax before creating the order
        total_amount = calculate_cart_total
        tax = calculate_tax

        # Save the order
        order = Order.create(
          user_id: current_user.id,
          total_amount: total_amount,
          tax: tax,
          status: "completed"
        )

        # Save each cart item
        session[:cart].each do |product_id, quantity|
          product = Product.find(product_id)
          OrderItem.create(
            order: order,
            product: product,
            quantity: quantity,
            price: product.price
          )
        end

        # Save payment
        Payment.create(
          order_id: order.id,
          payment_method: "Stripe",
          payment_status: "completed",
          amount_paid: total_amount + tax
        )

        flash[:notice] = "Payment successful! Thank you for your purchase. Your order ##{order.id} has been placed."
      else
        flash[:notice] = "Payment successful! Thank you for your purchase."
      end

      session[:cart] = {}
    else
      flash[:alert] = "No items in the cart to process the order."
    end

    redirect_to root_path
  end

  def calculate_cart_total
    session[:cart].sum do |product_id, quantity|
      product = Product.find_by(id: product_id)
      product ? (product.price * quantity) : 0
    end
  end

  def calculate_tax
    total = calculate_cart_total
    gst = (total * 0.05).round(2)
    pst = (total * 0.07).round(2)
    (gst + pst).round(2)
  end

  def cancel
    flash[:alert] = "Payment canceled. Please try again."
    redirect_to cart_path
  end

  private
end
