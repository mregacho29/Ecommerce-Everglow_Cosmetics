class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
    @orders = current_user.orders.includes(:order_items, :payment).order(created_at: :desc).page(params[:page]).per(5)
  end
end
