require 'open-uri'
require 'json'

# Clean up the database
Product.destroy_all
Category.destroy_all
# AdminUser.destroy_all
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





# Populate database with at least 20 products from an external API
url = 'http://makeup-api.herokuapp.com/api/v1/products.json'
response = URI.open(url).read
products = JSON.parse(response)

products.first(20).each do |product|
  category = Category.find_or_create_by(name: product['category'] || 'Uncategorized')
  Product.find_or_create_by(name: product['name']) do |p|
    p.description = product['description'] || 'No description available'
    p.price = product['price'].to_f
    p.stock_quantity = rand(10..100) # Random stock quantity
    p.image_url = product['image_link']
    p.category = category
  end
end

puts "20 Products seeded successfully!"


# Populate database with at least 10 products from Faker
# Define a list of makeup and skincare product names
makeup_and_skincare_products = [
  "Hydrating Face Cream",
  "Matte Lipstick",
  "Vitamin C Serum",
  "Waterproof Mascara",
  "Exfoliating Scrub",
  "Liquid Foundation",
  "Brightening Eye Cream",
  "Nourishing Hair Oil",
  "SPF 50 Sunscreen",
  "Charcoal Face Mask"
]

# Define a list of categories
categories = ["Skincare", "Makeup", "Haircare", "Sunscreen"]

# Seed the database with 10 products
makeup_and_skincare_products.each do |product_name|
  category = Category.find_or_create_by(name: categories.sample)
  Product.create!(
    name: product_name,
    description: Faker::Lorem.paragraph(sentence_count: 3),
    price: Faker::Commerce.price(range: 10..100.0),
    stock_quantity: rand(10..100),
    image_url: Faker::LoremFlickr.image(size: "300x300", search_terms: ['makeup', 'skincare']),
    category: category
  )
end

puts "10 makeup and skincare products created successfully!"
