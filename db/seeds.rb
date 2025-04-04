require 'open-uri'
require 'json'
require 'nokogiri'
require 'pexels'
require 'faker'

# Clean up the database
Product.destroy_all
Category.destroy_all
puts "Database cleaned!"



# Admin user creation
# # Fetch admin credentials from environment variables
# admin_email = ENV['ADMIN_EMAIL']
# admin_password = ENV['ADMIN_PASSWORD']

# if admin_email.present? && admin_password.present?
#   AdminUser.find_or_create_by!(email: admin_email) do |admin|
#     admin.password = admin_password
#     admin.password_confirmation = admin_password
#   end
#   puts "Admin user created with email: #{admin_email}"
# else
#   puts "Admin credentials are missing. Please set ADMIN_EMAIL and ADMIN_PASSWORD environment variables."
# end



# Fetch products from the external API
url = 'http://makeup-api.herokuapp.com/api/v1/products.json'
response = URI.open(url).read
products = JSON.parse(response)

# Initialize the Pexels client
pexels_client = Pexels::Client.new(ENV['PEXELS_API_KEY'])

# Fetch and cache images from Pexels
def fetch_cached_images(search_term, client, limit = 10)
  begin
    photos = client.photos.search(search_term, per_page: limit)
    photos.map { |photo| photo.src['medium'] }
  rescue Pexels::APIError => e
    puts "Pexels API error: #{e.message}. Using placeholder images."
    Array.new(limit, 'https://via.placeholder.com/300?text=No+Image+Available')
  end
end

# Scraper logic to fetch skincare products from Sephora
def scrape_sephora_skincare
  url = "https://www.sephora.com/ca/en/shop/skincare"
  doc = Nokogiri::HTML(URI.open(url))

  scraped_products = []
  doc.css('.css-12egk0t').each do |product_card| # Update the CSS selector if Sephora changes its structure
    name = product_card.css('.css-0').text.strip
    description = product_card.css('.css-1vwy1pm').text.strip # Adjust CSS selector for description
    price = product_card.css('.css-0 span').text.strip.gsub('$', '').to_f
    image_url = product_card.css('img').attr('src').value

    scraped_products << {
      name: name,
      description: description.presence || 'No description available.',
      price: price,
      image_url: image_url
    }
  end

  scraped_products
end

# Limit categories to 5 from the external API
puts "Creating makeup categories..."
allowed_makeup_categories = products.map { |product| product['category'] }.uniq.compact.first(5)
allowed_makeup_categories.each do |category_name|
  Category.create!(name: category_name)
end
puts "#{allowed_makeup_categories.size} makeup categories created!"

# Populate makeup categories
allowed_makeup_categories.each do |category_name|
  category_products = products.select { |product| product['category'] == category_name }
  category = Category.find_by(name: category_name)

  # Add products from the API
  category_products.first(100).each do |product|
    Product.create!(
      name: product['name'],
      description: product['description'].presence || 'No description available for this product.',
      price: product['price'].to_f > 0 ? product['price'].to_f : Faker::Commerce.price(range: 10..100.0),
      stock_quantity: rand(10..100), # Random stock quantity
      image_url: product['image_link'].presence || 'https://via.placeholder.com/300?text=No+Image+Available',
      category: category
    )
  end

  # If there are fewer than 100 products, fill the rest with Faker
  if Product.where(category: category).count < 100
    search_term = category_name.downcase.include?("makeup") ? "makeup" : "skincare"
    image_urls = fetch_cached_images(search_term, pexels_client, 10) # Fetch 10 images

    (100 - Product.where(category: category).count).times do
      Product.create!(
        name: Faker::Commerce.product_name,
        description: Faker::Lorem.paragraph(sentence_count: 3),
        price: Faker::Commerce.price(range: 10..100.0),
        stock_quantity: rand(10..100),
        image_url: image_urls.sample, # Randomly select a cached image
        category: category
      )
    end
  end
end

# Create a separate "Skincare" category
puts "Creating skincare category..."
skincare_category = Category.create!(name: "Skincare")

# Populate skincare category with Sephora scraper
scraped_skincare_products = scrape_sephora_skincare
scraped_skincare_products.first(100).each do |product|
  Product.create!(
    name: product[:name],
    description: product[:description],
    price: product[:price],
    stock_quantity: rand(10..100),
    image_url: product[:image_url],
    category: skincare_category
  )
end

# If there are fewer than 100 skincare products, fill the rest with Faker
if Product.where(category: skincare_category).count < 100
  image_urls = fetch_cached_images("skincare", pexels_client, 10) # Fetch 10 images

  (100 - Product.where(category: skincare_category).count).times do
    Product.create!(
      name: Faker::Commerce.product_name,
      description: Faker::Lorem.paragraph(sentence_count: 3),
      price: Faker::Commerce.price(range: 10..100.0),
      stock_quantity: rand(10..100),
      image_url: image_urls.sample, # Randomly select a cached image
      category: skincare_category
    )
  end
end
puts "Skincare category populated!"
