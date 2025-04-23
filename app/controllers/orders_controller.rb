class OrdersController < ApplicationController
  before_action :authenticate_user!
  def show
    @order = Order.find(params[:id])
    @breadcrumbs = [
      { name: "Home", path: root_path },
      { name: "Orders", path: orders_path },
      { name: "Order ##{@order.id}", path: order_path(@order) } # Current page
    ]
  end
  def index
    @orders = current_user.orders.includes(:order_items, :payment).order(created_at: :desc).page(params[:page]).per(5)
    @breadcrumbs = [
      { name: "Home", path: root_path },
      { name: "Orders", path: orders_path } # Current page
    ]
  end
end
