require 'open-uri'
require 'json'


AdminUser.destroy_all

# Fetch admin credentials from environment variables
admin_email = ENV['ADMIN_EMAIL']
admin_password = ENV['ADMIN_PASSWORD']

if admin_email.present? && admin_password.present?
  AdminUser.find_or_create_by!(email: admin_email) do |admin|
    admin.password = admin_password
    admin.password_confirmation = admin_password
  end
  puts "Admin user created with email: #{admin_email}"
else
  puts "Admin credentials are missing. Please set ADMIN_EMAIL and ADMIN_PASSWORD environment variables."
end





# Populate database with at least 10 products from an external API
url = 'http://makeup-api.herokuapp.com/api/v1/products.json'
response = URI.open(url).read
products = JSON.parse(response)

products.first(10).each do |product|
  category = Category.find_or_create_by(name: product['category'] || 'Uncategorized')
  Product.find_or_create_by(name: product['name']) do |p|
    p.description = product['description'] || 'No description available'
    p.price = product['price'].to_f
    p.stock_quantity = rand(10..100) # Random stock quantity
    p.image_url = product['image_link']
    p.category = category
  end
end

puts "Products seeded successfully!"