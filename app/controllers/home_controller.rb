class HomeController < ApplicationController
  def index
    @announcements = Announcement.all.order(created_at: :desc).limit(50)
    @top_picks = Product.all.order(created_at: :desc) # Fetch all products for Top Pick
    @sales = Product.where("price < ?", 50).order(created_at: :desc) # Fetch products with price below 50
  end
end
