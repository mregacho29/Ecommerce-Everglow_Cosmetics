class OrdersController < ApplicationController
  # List all past orders for the current user
  def index
    @orders = current_user.orders.includes(:order_items, :products).page(params[:page]).per(9) # Paginate with Kaminari
  end

  # Show details of a specific order
  def show
    @order = current_user.orders.find(params[:id]) # Ensure the order belongs to the current user
  end
end
