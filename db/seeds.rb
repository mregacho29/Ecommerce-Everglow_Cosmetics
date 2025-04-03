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