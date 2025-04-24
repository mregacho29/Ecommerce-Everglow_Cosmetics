class HomeController < ApplicationController
  def index
    @announcements = Announcement.all.order(created_at: :desc) # Fetch announcements
  end
end
