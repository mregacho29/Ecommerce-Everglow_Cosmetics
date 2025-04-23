class PaymentsController < ApplicationController
  def confirm
    order = Order.find(params[:order_id])
    if payment_successful?(order)
      order.update(status: :paid)
      flash[:notice] = "Order ##{order.id} has been marked as paid."
    else
      flash[:alert] = "Payment failed for Order ##{order.id}."
    end
    redirect_to order_path(order)
  end

  private

  def payment_successful?(order)
    # Retrieve the PaymentIntent from Stripe
    payment_intent = Stripe::PaymentIntent.retrieve(order.payment_intent_id)
    payment_intent.status == "succeeded"
  rescue Stripe::StripeError => e
    Rails.logger.error("Stripe error: #{e.message}")
    false
  end
end
