class PagesController < ApplicationController
  def show
    @page = Page.find_by!(slug: params[:slug])
  end

  def stores
    @store = {
      name: "Everglow Cosmetics Store",
      city: "New York",
      state: "NY",
      country: "USA",
      latitude: 40.7128,
      longitude: -74.0060,
      website: "https://everglowcosmetics.com"
    }

    @breadcrumbs = [
      { name: "Home", path: root_path },
      { name: "Stores", path: stores_path },
      { name: @store[:name], path: "#" }
    ]
  end
end
