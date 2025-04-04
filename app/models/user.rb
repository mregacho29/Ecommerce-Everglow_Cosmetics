class User < ApplicationRecord
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "email", "first_name", "id", "password_digest", "role", "updated_at"]
  end
end
