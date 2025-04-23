class CheckoutController < ApplicationController
  def create
    # Ensure the user has an address
    unless current_user.address.present?
      redirect_to new_address_path, alert: "Please add your shipping information before proceeding to checkout."
      return
    end


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
          currency: "cad", # Canadian Dollar
          product_data: {
            name: product.name,
            description: product.description
          },
          unit_amount: (product.price * 100).to_i # Stripe expects amounts in cents
        },
        quantity: quantity
      }
    end

    # Calculate tax based on the user's province
    tax = calculate_tax_for_user
    line_items << {
      price_data: {
        currency: "cad",
        product_data: {
          name: "Tax (GST + PST + HST)"
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
        tax_amount = calculate_tax_for_user # Calculate the tax amount

        # Fetch the user's province and associated tax record
        user_province = current_user.address&.province
        tax_record = Tax.find_by(province: user_province)

        # Save the order with the tax amount
        order = Order.create(
          user_id: current_user.id,
          total_amount: total_amount,
          tax_amount: tax_amount, # Save the calculated tax amount
          tax_id: tax_record&.id, # Assign the tax record's ID
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
          amount_paid: total_amount + tax_amount
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

  def calculate_tax_for_user
    total = calculate_cart_total

    # Fetch the province from the user's address
    user_province = current_user.address&.province
    tax_record = Tax.find_by(province: user_province)
    if tax_record.nil?
      flash[:alert] = "Tax information is missing for your province. Please contact support."
      redirect_to cart_path and return
    end

    # Calculate GST, PST, and HST based on the tax record
    gst = (total * tax_record.gst).round(2)
    pst = (total * tax_record.pst).round(2)
    hst = (total * tax_record.hst).round(2)

    # Return the total tax amount
    (gst + pst + hst).round(2)
  end

  def cancel
    flash[:alert] = "Payment canceled. Please try again."
    redirect_to cart_path
  end

  private
end
