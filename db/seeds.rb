<<<<<<< HEAD
require 'open-uri'
require 'json'
require 'nokogiri'
require 'pexels'
require 'faker'
require_relative '../lib/scraper'

# Clean up the database
Product.destroy_all
Category.destroy_all
puts "Database cleaned!"



# Admin user creation
# # Fetch admin credentials from environment variables
# admin_email = ENV['ADMIN_EMAIL']
# admin_password = ENV['ADMIN_PASSWORD']
=======
# require 'open-uri'
# require 'json'
# require 'pexels'
# require 'faker'

# # Clean up the database
# Product.destroy_all
# Category.destroy_all
# # AdminUser.destroy_all
# puts "Database cleaned!"




# # Admin user creation
# # # Fetch admin credentials from environment variables
# # admin_email = ENV['ADMIN_EMAIL']
# # admin_password = ENV['ADMIN_PASSWORD']
>>>>>>> 9749d662a58a485f02da21f582991978faa36c92

# # if admin_email.present? && admin_password.present?
# #   AdminUser.find_or_create_by!(email: admin_email) do |admin|
# #     admin.password = admin_password
# #     admin.password_confirmation = admin_password
# #   end
# #   puts "Admin user created with email: #{admin_email}"
# # else
# #   puts "Admin credentials are missing. Please set ADMIN_EMAIL and ADMIN_PASSWORD environment variables."
# # end



# # Fetch products from the external API
# url = 'http://makeup-api.herokuapp.com/api/v1/products.json'
# response = URI.open(url).read
# products = JSON.parse(response)


# # Initialize the Pexels client
# pexels_client = Pexels::Client.new(ENV['PEXELS_API_KEY'])

# # Fetch and cache images from Pexels
# def fetch_cached_images(search_term, client, limit = 10)
#   begin
#     photos = client.photos.search(search_term, per_page: limit)
#     photos.map { |photo| photo.src['medium'] }
#   rescue Pexels::APIError => e
#     puts "Pexels API error: #{e.message}. Using placeholder images."
#     Array.new(limit, 'https://via.placeholder.com/300?text=No+Image+Available')
#   end
# end



<<<<<<< HEAD

# Fetch products from the external API
url = 'http://makeup-api.herokuapp.com/api/v1/products.json'
response = URI.open(url).read
products = JSON.parse(response)

# Initialize the Pexels client
pexels_client = Pexels::Client.new(ENV['PEXELS_API_KEY'])
=======
# # Populate categories dynamically from the API
# puts "Creating categories..."
# categories = products.map { |product| product['category'] }.uniq.compact
# categories.each do |category_name|
#   Category.create!(name: category_name)
# end
# puts "#{categories.size} categories created!"

# # Ensure each category has 100 products
# puts "Creating products for each category..."
# categories.each do |category_name|
#   category_products = products.select { |product| product['category'] == category_name }
#   category = Category.find_by(name: category_name)

#   # Add products for the category
#   category_products.first(100).each do |product|
#     Product.create!(
#       name: product['name'],
#       description: product['description'].presence || 'No description available for this product.',
#       price: product['price'].to_f > 0 ? product['price'].to_f : Faker::Commerce.price(range: 10..100.0),
#       stock_quantity: rand(10..100), # Random stock quantity
#       image_url: product['image_link'].presence || 'https://via.placeholder.com/300?text=No+Image+Available',
#       category: category
#     )
#   end

# # If there are fewer than 100 products in the API for this category, fill the rest with Faker
# # Fill the remaining products for the category
# if category_products.size < 100
#   # Define custom product names for makeup and skincare categories
#   makeup_products = [
#     "Matte Lipstick",
#     "Waterproof Mascara",
#     "Blush Palette",
#     "Eyeliner Pen",
#     "Liquid Foundation",
#     "Lip Gloss",
#     "Eyeshadow Palette",
#     "Highlighter Stick",
#     "Brow Gel",
#     "Setting Spray"
#   ]

#   skincare_products = [
#     "Hydrating Face Cream",
#     "Vitamin C Serum",
#     "Exfoliating Scrub",
#     "Brightening Eye Cream",
#     "Charcoal Face Mask",
#     "Anti-Aging Night Cream",
#     "Facial Toner",
#     "Moisturizing Primer",
#     "SPF 50 Sunscreen",
#     "Makeup Remover"
#   ]

#   # Determine the appropriate product list based on the category
#   product_list = if category_name.downcase.include?("makeup")
#                    makeup_products
#   elsif category_name.downcase.include?("skincare")
#                    skincare_products
#   else
#                    makeup_products + skincare_products # Default to a mix of both
#   end

#   # Fetch images for the category
#   search_term = category_name.downcase.include?("makeup") ? "makeup" : "skincare"
#   image_urls = fetch_cached_images(search_term, pexels_client, 10) # Fetch 10 images

#   # Fill the remaining products for the category
#   (100 - category_products.size).times do
#     Product.create!(
#       name: product_list.sample, # Randomly select a product name from the appropriate list
#       description: Faker::Lorem.paragraph(sentence_count: 3),
#       price: Faker::Commerce.price(range: 10..100.0),
#       stock_quantity: rand(10..100),
#       image_url: image_urls.sample, # Randomly select a cached image
#       category: category
#     )
#   end
# end
# end
# puts "Products created for each category!"


>>>>>>> 9749d662a58a485f02da21f582991978faa36c92

# Create tax records
Tax.create([
  { province: "Ontario", gst: 0.05, pst: 0.00, hst: 0.13 },
  { province: "Quebec", gst: 0.05, pst: 0.09975, hst: 0.00 },
  { province: "British Columbia", gst: 0.05, pst: 0.07, hst: 0.00 },
  { province: "Alberta", gst: 0.05, pst: 0.00, hst: 0.00 },
  { province: "Manitoba", gst: 0.05, pst: 0.07, hst: 0.00 },
  { province: "New Brunswick", gst: 0.00, pst: 0.00, hst: 0.15 },
  { province: "Newfoundland and Labrador", gst: 0.00, pst: 0.00, hst: 0.15 },
  { province: "Northwest Territories", gst: 0.05, pst: 0.00, hst: 0.00 },
  { province: "Nova Scotia", gst: 0.00, pst: 0.00, hst: 0.15 },
  { province: "Nunavut", gst: 0.05, pst: 0.00, hst: 0.00 },
  { province: "Prince Edward Island", gst: 0.00, pst: 0.00, hst: 0.15 },
  { province: "Saskatchewan", gst: 0.05, pst: 0.06, hst: 0.00 },
  { province: "Yukon", gst: 0.05, pst: 0.00, hst: 0.00 }
])

# Assign a default tax to existing orders
default_tax = Tax.find_by(province: "Manitoba") # Replace with your default province
if default_tax
  Order.update_all(tax_id: default_tax.id)
else
  puts "Default tax record not found. Please check the Tax table."
end
