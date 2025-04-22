require 'open-uri'
require 'json'
require 'nokogiri'
require 'pexels'
require 'faker'
require_relative '../lib/scraper'

# # Clean up the database
# Product.destroy_all
# Category.destroy_all
# puts "Database cleaned!"



# # Admin user creation
# # # Fetch admin credentials from environment variables
# # admin_email = ENV['ADMIN_EMAIL']
# # admin_password = ENV['ADMIN_PASSWORD']

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

# # Limit categories to 5 from the external API
# puts "Creating makeup categories..."
# allowed_makeup_categories = products.map { |product| product['category'] }.uniq.compact.first(5)
# allowed_makeup_categories.each do |category_name|
#   Category.create!(name: category_name)
# end
# puts "#{allowed_makeup_categories.size} makeup categories created!"

# # Populate makeup categories
# allowed_makeup_categories.each do |category_name|
#   category_products = products.select { |product| product['category'] == category_name }
#   category = Category.find_by(name: category_name)

#   # Add products from the API
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

#   # If there are fewer than 100 products, fill the rest with Faker
#   if Product.where(category: category).count < 100
#     search_term = category_name.downcase.include?("makeup") ? "makeup" : "skincare"
#     image_urls = fetch_cached_images(search_term, pexels_client, 10) # Fetch 10 images

#     (100 - Product.where(category: category).count).times do
#       Product.create!(
#         name: Faker::Commerce.product_name,
#         description: Faker::Lorem.paragraph(sentence_count: 3),
#         price: Faker::Commerce.price(range: 10..100.0),
#         stock_quantity: rand(10..100),
#         image_url: image_urls.sample, # Randomly select a cached image
#         category: category
#       )
#     end
#   end
# end

# # Create a separate "Skincare" category
# puts "Creating skincare category..."
# skincare_category = Category.create!(name: "Skincare")

# # Populate skincare category with Proactiv scraper
# puts "Scraping skincare products from Proactiv..."
# scraped_skincare_products = ProactivScraper.scrape_skincare

# if scraped_skincare_products.any?
#   scraped_skincare_products.each do |product|
#     Product.create!(
#       name: product[:name],
#       description: product[:description],
#       price: product[:price],
#       stock_quantity: rand(10..100), # Generate a random stock quantity
#       image_url: product[:image_url],
#       category: skincare_category
#     )
#   end
#   puts "Successfully added #{scraped_skincare_products.size} products to the Skincare category."
# else
#   puts "No products were scraped from Proactiv."
# end

# # If there are fewer than 100 skincare products, fill the rest with predefined skincare names
# if Product.where(category: skincare_category).count < 100
#   image_urls = fetch_cached_images("skincare", pexels_client, 20)

#   skincare_names = [
#     "Hydrating Facial Cleanser",
#     "Vitamin C Serum",
#     "Retinol Night Cream",
#     "Hyaluronic Acid Moisturizer",
#     "Exfoliating Face Scrub",
#     "SPF 50 Sunscreen",
#     "Anti-Aging Eye Cream",
#     "Charcoal Detox Mask",
#     "Aloe Vera Gel",
#     "Collagen Boosting Serum",
#     "Tea Tree Oil Cleanser",
#     "Brightening Toner",
#     "Soothing Face Mist",
#     "Deep Pore Cleansing Mask",
#     "Oil-Free Moisturizer"
#   ]

#   (100 - Product.where(category: skincare_category).count).times do
#     Product.create!(
#       name: skincare_names.sample, # Randomly select a skincare name
#       description: Faker::Lorem.paragraph(sentence_count: 3),
#       price: Faker::Commerce.price(range: 10..100.0),
#       stock_quantity: rand(10..100),
#       image_url: image_urls.sample, # Randomly select a cached image
#       category: skincare_category
#     )
#   end
# end

# puts "Skincare category populated!"







# # # Add default "Contact" and "About" pages in your seeds.rb file:
# # # Create default pages
# # Page.find_or_create_by!(slug: "contact") do |page|
# #   page.title = "Contact"
# #   page.content = "This is the contact page. Update this content from ActiveAdmin."
# # end

# # Page.find_or_create_by!(slug: "about") do |page|
# #   page.title = "About"
# #   page.content = "This is the about page. Update this content from ActiveAdmin."
# # end




# Define tags and their associated keywords
tags_keywords = {
  'Skincare' => [ 'moisturizers', 'treatments', 'cleanser', 'hydrating', 'serum', 'spf', 'sunscreen' ],
  'Makeup' => [ 'lip', 'cheek', 'eye', 'blush', 'bronzer', 'highlighter', 'contour' ],
  'Pencil' => [ 'eyeliner', 'mascara', 'eye pencil', 'brow pencil', 'kohl', 'sharpener' ],
  'Lipstick' => [ 'cream', 'liquid lipstick', 'matte', 'gloss', 'lip balm', 'lip stain' ],
  'Liquid' => [ 'foundation', 'marker', 'eyeliner', 'concealer', 'serum', 'tint' ],
  'Powder' => [ 'setting powder', 'foundation', 'blush', 'bronzer', 'highlighter', 'compact' ]
}

# Create tags in the database
tags_keywords.keys.each do |tag_name|
  Tag.find_or_create_by!(name: tag_name)
end

# Associate tags with existing products based on name or description
Product.find_each do |product|
  tags_keywords.each do |tag_name, keywords|
    # Check if any keyword matches the product's name or description
    if keywords.any? { |keyword| product.name.downcase.include?(keyword) || product.description.to_s.downcase.include?(keyword) }
      tag = Tag.find_by(name: tag_name)
      product.tags << tag unless product.tags.include?(tag)
    end
  end
end

puts "Tags associated with existing products based on name and description!"
